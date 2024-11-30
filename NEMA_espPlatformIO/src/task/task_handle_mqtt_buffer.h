#ifndef TASK_HANDDLE_MQTT_BUFFER_H
#define TASK_HANDDLE_MQTT_BUFFER_H

#include "globals.h"

extern std :: vector<String> mqttBuffer;

void bufferInit();
void taskHandleMqttBuffer(void *pvParameter);

#endif