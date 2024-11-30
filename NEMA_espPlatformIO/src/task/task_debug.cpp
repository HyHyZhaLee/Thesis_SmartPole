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

void taskDummySendMqtt(void *pvParameter)
{
  while (true)
  {
    publishData(MQTT_FEED_POLE_02, lightControl.genStringFromJson());

    vTaskDelay(pdMS_TO_TICKS(delay_lora_dummy_send));
  }
}