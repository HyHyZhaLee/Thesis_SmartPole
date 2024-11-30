#include "task_handle_mqtt_buffer.h"

std :: vector<String> mqttBuffer;

void bufferInit()
{
  // buffer clearup
  mqttBuffer.clear();
}

void taskHandleMqttBuffer(void *pvParameter)
{
  bufferInit();
  printlnData(MQTT_FEED_NOTHING, "INIT ONE TIME");
  
  while (true)
  {
    if (!mqttBuffer.empty())
    {
      // Cause using push back so front is the oldest one
      String stringJson = mqttBuffer.front();
      mqttBuffer.erase(mqttBuffer.begin());
      LightControl lightControl(stringJson);

      if (lightControl.getAction().compareTo("control light") == 0)
      { // This part is for control this device
        if (lightControl.getDeviceId().compareTo(DEVICE_ID) == 0)
        {
          if (lightControl.getDimming().compareTo("0") == 0)
          {
            printlnData(MQTT_FEED_NOTHING, "Recv from mqtt turn off light");  
          }
          else
          {
            printlnData(MQTT_FEED_NOTHING, "Recv from mqtt turn on light");
          }

          int dutyPercent = lightControl.getDimming().toInt();
          pwm_set_duty(dutyPercent);
        }
        else
        {
          printlnData(MQTT_FEED_NOTHING, lightControl.getDeviceId());
          loraSend(lightControl.genStringFromJson()); 
          printlnData(MQTT_FEED_NOTHING, "control light");
        }
      }
    }

    vTaskDelay(delay_handle_mqtt_buffer);
  }
}