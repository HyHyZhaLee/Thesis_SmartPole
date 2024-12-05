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
        if (lightControl.getTo().compareTo(DEVICE_ID) == 0)
        {
          int dutyPercent = lightControl.getDimming().toInt();

          if (dutyPercent == 0)
          {
            digitalWrite(RELAY_PIN, RELAY_OFF);
            printlnData(MQTT_FEED_NOTHING, "Recv from mqtt turn off light");  
          }
          else
          {
            digitalWrite(RELAY_PIN, RELAY_ON);
            printlnData(MQTT_FEED_NOTHING, "Recv from mqtt turn on light");
          }

          pwm_set_duty(dutyPercent);
        }
        else
        {
          printlnData(MQTT_FEED_NOTHING, lightControl.getDeviceId());
          // This one is place for lora sending process

          process_ack_waitting process = 
          {
            LORA_TIMER_FACTOR_MSG_RESEND,
            LORA_MAX_TIMES_RESEND,
            lightControl.getTo(),
            lightControl.getDimming()
          };

          if (loraSend(lightControl.genStringFromJson()))
          {
            lora_waiting_ack_list.push_back(process);
          }
          printlnData(MQTT_FEED_NOTHING, "control light");
        }
      }
    }

    vTaskDelay(delay_handle_mqtt_buffer);
  }
}