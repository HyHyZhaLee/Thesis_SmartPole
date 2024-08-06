// #include <stdio.h>

#ifndef TASK_H_
#define TASK_H_

#include <wifi_setup.h>
#include <MQTT_helper.h>
#include <JsonHelper.h>
#include <Watch_dog.h>

void taskHandlePoleControl (void*);
void taskPublish2Server(void*);

extern MyMQTT atom_MQTT;


#endif