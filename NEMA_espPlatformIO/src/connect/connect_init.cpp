#include "connect_init.h"

void connect_init() 
{
  xTaskCreatePinnedToCore(taskWifi, "taskWifi", 4096, NULL, 1, NULL, 0);
  xTaskCreatePinnedToCore(taskMQTT, "taskMQTT", 4096, NULL, 1, NULL, 0);
  xTaskCreatePinnedToCore(taskLoraInit, "taskLora", 4096, NULL, 1, NULL, 0);
  xTaskCreatePinnedToCore(taskLoraRecv, "taskLoraRecv", 4096, NULL, 0, NULL, 1);
  xTaskCreatePinnedToCore(taskLoraSend, "taskLoraSend", 4096, NULL, 1, NULL,1);
}