#include "task_debug.h"

LightControl lightControl(
  "NEMA_0003",
  "NEMA_0003",
  "control light",
  "NEMA_0003",
  "NEMA_0003",
  "NEMA_0002",
  "30"
);

int counter = 100;
int relay_status = RELAY_ON;

void taskDummySendMqtt(void *pvParameter)
{
  while (true)
  {
    publishData(MQTT_FEED_POLE_02, lightControl.genStringFromJson());

    vTaskDelay(pdMS_TO_TICKS(delay_lora_dummy_send));
  }
}

void taskDimmingDebug(void *pvParameter)
{
  pinMode (RELAY_PIN, OUTPUT);
  relay_status = RELAY_ON;
  digitalWrite(RELAY_PIN, HIGH);

  while (true)
  {
    if (counter == 0)
    {
      counter = 100;
      if (relay_status == RELAY_ON)
      {
        digitalWrite(RELAY_PIN, RELAY_OFF);
        relay_status = RELAY_OFF;
      }
      else
      {
        digitalWrite(RELAY_PIN, RELAY_ON);
        relay_status = RELAY_ON;
      }
    }
    pwm_set_duty(counter);
    counter --;

    vTaskDelay(100);
  }
}