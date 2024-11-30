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