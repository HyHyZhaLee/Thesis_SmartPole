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
      printlnData(MQTT_FEED_NOTHING, "recv mess: " + stringJson);
      
      if (stringJson[0] == '{' && stringJson.endsWith("}"))
      {
        LightControl light_control(stringJson);
        if (light_control.getTo().compareTo(DEVICE_ID) == 0
            && light_control.getAction().compareTo("ack: control light") == 0
        )
        {
          String ackFromDevice = light_control.getFrom();
          String ackDimming = light_control.getDimming();

          std :: vector<process_ack_waitting>::iterator it = lora_waiting_ack_list.begin();
          for (it = lora_waiting_ack_list.begin(); it != lora_waiting_ack_list.end(); it++)
          {
            process_ack_waitting curElement = *it;
            printlnData(MQTT_FEED_NOTHING, ackFromDevice);
            printlnData(MQTT_FEED_NOTHING, ackDimming);

            if (ackFromDevice.compareTo(it->deviceId) == 0
                && ackDimming.compareTo(it->deviceDimming) == 0)
            {
              printlnData(MQTT_FEED_NOTHING, it->deviceId);
              printlnData(MQTT_FEED_NOTHING, it->deviceDimming);

              if (xSemaphoreTake(semaphoreLora, portMAX_DELAY) == pdTRUE)
              {
                lora_waiting_ack_list.erase(it);
                printlnData(MQTT_FEED_NOTHING, "erase out of the process");
                printlnData(MQTT_FEED_NOTHING, String(lora_waiting_ack_list.size()));
                xSemaphoreGive(semaphoreLora);
              }
              break;
            }    
          }
        }
      }
      else 
      {
        printlnData(MQTT_FEED_NOTHING, "recv mess: " + stringJson);
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
      while (it != lora_waiting_ack_list.end())
      {
        if (it->counter_resend <= 0)
        {
          if (xSemaphoreTake(semaphoreLora, portMAX_DELAY) == pdTRUE)
          {
            printlnData(MQTT_FEED_TEST_LORA_SEND, "Error: Received ACK from " 
              + it->deviceId
              + " failed");

            // publish data error announcement  
            publishData(MQTT_FEED_TEST_LORA_SEND, "Error: Received ACK from "
              + it->deviceId
              + " failed");

            xSemaphoreGive(semaphoreLora);
          }

          it = lora_waiting_ack_list.erase(it);
          continue;
        }
        else if (it->timer_factor <= 0)
        {
          it->counter_resend --;
          it->timer_factor = LORA_TIMER_FACTOR_MSG_RESEND;
          
          LightControl lightControl 
          (
            STATION_ID,
            DEVICE_ID,
            "light control",
            DEVICE_ID,
            DEVICE_ID,
            it->deviceId,
            it->deviceDimming
          );
          printlnData(MQTT_FEED_NOTHING, "Resend: ");
          loraSend(lightControl.genStringFromJson());
        }
        else if (it->timer_factor > 0)
        {
          it->timer_factor --;
          printlnData(MQTT_FEED_NOTHING, "timer_factor: " + String(it->timer_factor));
          printlnData(MQTT_FEED_NOTHING, "counter_resend: " + String(it->counter_resend));
        }

        it++;
      }
    }
    vTaskDelay(1000);
  }
  vTaskDelete(NULL);
}