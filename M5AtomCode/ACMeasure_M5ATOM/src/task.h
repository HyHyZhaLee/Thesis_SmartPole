// #include <stdio.h>

#ifndef TASK_H_
#define TASK_H_

#include <wifi_setup.h>
#include <MQTT_helper.h>
#include <JsonHelper.h>
#include <Watch_dog.h>
#include <M5Atom.h>
#include <main.h>

void taskHandlePoleControl (void*);
void taskPublish2Server(void*);
void taskHandleControlFlag (void*);




#endif