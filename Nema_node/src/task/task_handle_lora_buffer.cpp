#include "task_handle_lora_buffer.h"

std :: vector<String> lora_buffer;

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
            && light_control.getAction().compareTo("control light") == 0)
        {
          printlnData(MQTT_FEED_NOTHING, "recv mess " + stringJson);
            
          LightControl light_control_ack(
            STATION_ID,
            STATION_NAME,
            "ack: control light",
            DEVICE_ID,
            DEVICE_ID,
            light_control.getFrom(),
            light_control.getDimming()
          );

          loraSend(light_control_ack.genStringFromJson());

          if (light_control.getDimming().toInt() != 0)
          {
            setRelayOn();
            pwm_set_duty(light_control.getDimming().toInt());
          }
          else
          {
            setRelayOff();
            pwm_set_duty(light_control.getDimming().toInt());
          }
        }
      }
      else
      {
        printlnData(MQTT_FEED_NOTHING, "recv mess " + stringJson);
      }
    }
    vTaskDelay(delay_handle_lora_buffer);
  }
}
