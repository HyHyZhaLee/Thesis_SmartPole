// #include <stdio.h>

#ifndef TASK_H_
#define TASK_H_

#include <wifi_setup.h>
// #include <MQTT_helper.h>
#include <JsonHelper.h>
#include <Watch_dog.h>
#include <M5Atom.h>
#include <main.h>


#define TIME_DEBOUNCING_FACTOR          5
#define TIME_DELAY_TURN_OFF_FACTOR      750 //250 * 20


#define TURN_ON_SIGNAL                  LOW
#define TURN_OFF_SIGNAL                 HIGH

#define INIT_STATE                      0
#define HAVE_PERSON                     1
#define DONT_HAVE_PERSON                2

#define BLUE                            0x0000f0
#define GREEN                           0x00ff00
#define BLACK                           0x000000
#define WHITE                           0xffffff
#define RED                             0xff0000
#define ORANGE                          0xffa500

void taskLedBlink(void*);
void taskPublish2Server(void*);
void taskHandleControlFlag (void*);

class MyMQTT;
extern String feedPole_01;
extern MyMQTT atom_MQTT;
extern int led_color;
extern bool MQTT_disconnect_flag;

#endif