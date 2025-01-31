#include "task_relay_control.h"

int relay_status = RELAY_ON;

void taskInitRelayControl(void *pvParameter)
{
  addTaskToWatchdog(NULL);
  pinMode(RELAY_PIN, OUTPUT);
  relay_status = RELAY_OFF;
  digitalWrite(RELAY_PIN, RELAY_OFF);

  resetWatchdog();
  removeTaskFromWatchdog(NULL);
  vTaskDelete(NULL); 
}

void setRelayOn()
{
  digitalWrite(RELAY_PIN, RELAY_ON);
  printlnData(MQTT_FEED_NOTHING, "Turn relay on");
}

void setRelayOff()
{
  digitalWrite(RELAY_PIN, RELAY_OFF);
  printlnData(MQTT_FEED_NOTHING, "Turn relay off");
}