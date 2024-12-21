#include "connect_init.h"

void connect_init() 
{
  xTaskCreate(taskLoraInit, "taskLora", 4096, NULL, 1, NULL);
  xTaskCreate(taskLoraRecv, "taskLoraRecv", 4096, NULL, 1, NULL);
  xTaskCreate(taskLoraSendDebug, "taskLoraSend", 4096, NULL, 1, NULL);
}