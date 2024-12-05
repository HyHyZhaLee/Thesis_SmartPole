#include "task_init.h"

void task_init()
{
  xTaskCreate(taskHandleMqttBuffer, "taskHandleMqttBuffer", 4096, NULL, 1, NULL);
  xTaskCreate(taskHandleLoraBuffer, "taskHandleLoraBuffer",4096 , NULL, 1, NULL);
  xTaskCreate(taskWaitingAckProcess, "taskWaitingAckProcess",4096 , NULL, 1, NULL);
  // xTaskCreate(taskDimmingDebug, "taskDimmingDebug",4096 , NULL, 1, NULL);
  xTaskCreate(taskDummySendMqtt, "taskDummySendMqtt",4096 , NULL, 1, NULL);
}