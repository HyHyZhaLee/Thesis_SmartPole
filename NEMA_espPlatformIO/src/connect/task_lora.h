#ifndef TASK_LORA_H
#define TASK_LORA_H

#include "globals.h"

extern LoRa_E220_JP lora;

void taskLora(void *pvParameters);
void taskLoraRecv(void *pvParameters);
void taskLoraSend(void *pvParameters);


#endif