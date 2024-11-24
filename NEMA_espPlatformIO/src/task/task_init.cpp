#include "task_init.h"

void task_init()
{
  xTaskCreate(taskTestDimming, "taskTestDimming", 4096, NULL, 1, NULL);
  xTaskCreate(taskDebugMQTT, "taskDebugMQTT", 4096, NULL, 1, NULL);
  xTaskCreate(taskLedBlink, "taskLedBlink", 4096, NULL, 1, NULL);
}