#include "task_handle_lora_buffer.h"

std :: vector<String> lora_buffer;
std :: vector<process_ack_waitting> lora_waiting_ack_list;

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

        if (light_control.getDeviceId().compareTo(DEVICE_ID) == 0)
        {
          LightControl light_control_ack(
            STATION_ID,
            STATION_NAME,
            "ack: light control",
            DEVICE_ID,
            DEVICE_ID,
            light_control.getFrom(),
            light_control.getDimming()
          );

          loraSend(light_control_ack.genStringFromJson());
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
void lora_resend_light_control_process(void *pvParameters)
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
        String waiting_device_id = curElement.device.getTo();

        if (curElement.is_recv_ack != false)
        {
          lora_waiting_ack_list.erase(it);
        }
        else // false
        {
          if (curElement.counter_resend <= 0)
          {
            printlnData(MQTT_FEED_TEST_LORA_SEND, "Error: Received ACK from " 
              + waiting_device_id 
              + " failed");
            
            lora_waiting_ack_list.erase(it);
          }
          else if (curElement.timer_factor <= 0)
          {
            curElement.counter_resend --;
            curElement.timer_factor = LORA_TIMER_FACTOR_MSG_RESEND;
            loraSend(curElement.device.genStringFromJson());
          }
          else if (curElement.timer_factor > 0)
          {
            curElement.timer_factor --;
          }
        }
      }
    }
  }
  


}