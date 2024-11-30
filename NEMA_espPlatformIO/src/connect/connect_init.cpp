#include "connect_init.h"

void connect_init() 
{
  xTaskCreate(taskWifi, "taskWifi", 4096, NULL, 1, NULL);
  xTaskCreate(taskMQTT, "taskMQTT", 4096, NULL, 1, NULL);
  xTaskCreate(taskLoraInit, "taskLora", 4096, NULL, 1, NULL);
  xTaskCreate(taskLoraRecv, "taskLoraRecv", 4096, NULL, 1, NULL);
  xTaskCreate(taskLoraSend, "taskLoraSend", 4096, NULL, 1, NULL);
}