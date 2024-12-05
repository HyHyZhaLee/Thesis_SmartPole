#include "task_init.h"

void task_init()
{
  // xTaskCreate(taskHandleMqttBuffer, "taskHandleMqttBuffer", 4096, NULL, 1, NULL);
  #ifdef _ESP_NUMBER_TWO_ 
    xTaskCreate(taskDummySendMqtt, "taskDummySendMqtt",4096 , NULL, 1, NULL);
  #endif
  // xTaskCreate(taskHandleLoraBuffer, "taskHandleLoraBuffer",4096 , NULL, 1, NULL);
  xTaskCreate(taskDimmingDebug, "taskDimmingDebug",4096 , NULL, 1, NULL);
}