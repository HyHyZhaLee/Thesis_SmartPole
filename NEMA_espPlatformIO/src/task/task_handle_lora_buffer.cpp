#include "task_handle_lora_buffer.h"

std :: vector<String> lora_buffer;
std :: vector<process_ack_waitting> lora_waiting_ack_list;

SemaphoreHandle_t semaphoreLora;

void initLoreBuffer()
{
  lora_buffer.clear();
}

void taskHandleLoraBuffer(void *pvParameter)
{
  initLoreBuffer();

  while (true)
  {
    if (!lora_buffer.empty())
    {
      // Cause using push back so front is the oldest one
      String stringJson = lora_buffer.front(); 
      lora_buffer.erase(lora_buffer.begin());

      if (stringJson[0] == '{' && stringJson.endsWith("}"))
      {
        LightControl light_control(stringJson);

        if (light_control.getTo().compareTo(DEVICE_ID) == 0
            && light_control.getAction().compareTo("ack: light control") == 0
        )
        {
          String ackFromDevice = light_control.getFrom();
          String ackDimming = light_control.getDimming();

          std :: vector<process_ack_waitting>::iterator it = lora_waiting_ack_list.begin();
          for (it = lora_waiting_ack_list.begin(); it != lora_waiting_ack_list.end(); it++)
          {
            process_ack_waitting curElement = *it;
            if (ackFromDevice.compareTo(curElement.deviceId) == 0
                && ackDimming.compareTo(curElement.deviceDimming) == 0)
            {
              if (xSemaphoreTake(semaphoreLora, portMAX_DELAY) == pdTRUE)
              {
                lora_waiting_ack_list.erase(it);
                xSemaphoreGive(semaphoreLora);
              }
              break;
            }    
          }
        }
      }
    }
    vTaskDelay(delay_handle_lora_buffer);
  }
}


void init_waiting_ack_list()
{
  lora_waiting_ack_list.clear();
}

// Process count down timer for resend messages
void taskWaitingAckProcess(void *pvParameter)
{
  init_waiting_ack_list();

  while (true)
  {
    if (!lora_waiting_ack_list.empty())
    {
      std :: vector<process_ack_waitting>::iterator it = lora_waiting_ack_list.begin();
      for (it = lora_waiting_ack_list.begin(); it != lora_waiting_ack_list.end(); it++)
      {
        process_ack_waitting curElement = *it;
        String waiting_device_id = curElement.deviceId;

        if (curElement.counter_resend <= 0)
        {
          printlnData(MQTT_FEED_TEST_LORA_SEND, "Error: Received ACK from " 
            + waiting_device_id 
            + " failed");
          if (xSemaphoreTake(semaphoreLora, portMAX_DELAY) == pdTRUE)
          {
            lora_waiting_ack_list.erase(it);
            xSemaphoreGive(semaphoreLora);
          }
        }
        else if (curElement.timer_factor <= 0)
        {
          curElement.counter_resend --;
          curElement.timer_factor = LORA_TIMER_FACTOR_MSG_RESEND;
          
          LightControl lightControl 
          (
            STATION_ID,
            DEVICE_ID,
            "light control",
            DEVICE_ID,
            DEVICE_ID,
            curElement.deviceId,
            curElement.deviceDimming
          );
          loraSend(lightControl.genStringFromJson());
        }
        else if (curElement.timer_factor > 0)
        {
          curElement.timer_factor --;
        }
      }
    }
  }
}