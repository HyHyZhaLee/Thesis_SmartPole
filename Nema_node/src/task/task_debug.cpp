#include "task_debug.h"

LightControl lightControl(
  "NEMA_0003",
  "NEMA_0003",
  "control light",
  "NEMA_0003",
  "NEMA_0003",
  "NEMA_0002",
  "30"
);

int counter = 0;
bool counterState = COUNT_UP;


void taskDimmingDebug(void *pvParameter)
{
  while (true)
  {
    if (counter < 0)
    {
      counter = 0;
      counterState = COUNT_UP;
      setRelayOn();
    }
    else if (counter > 100)
    {
      counter = 100;
      counterState = COUNT_DOWN;
      setRelayOff();
    }
    else 
    {
      if (counterState == COUNT_UP)
      {
        counter ++;
      }
      else
      {
        counter --;
      }
    }
    printlnData(MQTT_FEED_NOTHING, String(counter));

    pwm_set_duty(counter);
    vTaskDelay(100);
  }
}