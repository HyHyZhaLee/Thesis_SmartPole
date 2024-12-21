#ifndef TASK_LORA_H
#define TASK_LORA_H

#include "globals.h"

extern LoRa_E220_JP lora;

void taskLoraInit(void *pvParameters);
void taskLoraRecv(void *pvParameters);
void taskLoraSend(void *pvParameters);
bool loraSend(String message);


#endif