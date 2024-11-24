#include "task_handle_mqtt_buffer.h"

std :: vector<String> mqttBuffer;

void bufferInit()
{
  // buffer clearup
  mqttBuffer.clear();
}

void handleMqttBuffer(void *pvParameter)
{
  bufferInit();
  while (true)
  {
    if (!mqttBuffer.empty())
    {
      String stringJson = mqttBuffer.front();
      mqttBuffer.erase(mqttBuffer.begin());

      DynamicJsonDocument document(1024);
      deserializeJson(document, stringJson);

      LightControl lightControl(document);
      
      const char *cstrDeviceId = lightControl.getDeviceId().c_str();
      const char *cstrActiion = lightControl.getAction().c_str();
      
      if (strcmp(cstrDeviceId , "NEMA_0002") == 0
          && strcmp(cstrActiion , "control light") == 0)
      {
        int dutyPercent = lightControl.getDimming().toInt();
        pwm_set_duty(dutyPercent);
      }
      else if (strcmp(cstrActiion , "control light") == 0)
      {
        
      }
    }
    vTaskDelay(pdMS_TO_TICKS(delay_handle_mqtt_buffer));
  }

  
  
}
