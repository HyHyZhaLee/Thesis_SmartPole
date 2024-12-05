#include "task_debug.h"

LightControl lightControl(
  "NEMA_0002",
  "NEMA_0002",
  "control light",
  "NEMA_0002",
  "NEMA_0002",
  "NEMA_0002",
  "10"
);

LightControl lightControl2(
  "NEMA_0002",
  "NEMA_0002",
  "control light",
  "NEMA_0002",
  "NEMA_0002",
  "NEMA_0002",
  "0"
);

LightControl lightControl3(
  "NEMA_0002",
  "NEMA_0002",
  "control light",
  "NEMA_0002",
  "NEMA_0002",
  "NEMA_0002",
  "90"
);


LightControl lightControl4(
  "NEMA_0002",
  "NEMA_0002",
  "control light",
  "NEMA_0002",
  "NEMA_0002",
  "NEMA_0002",
  "20"
);

LightControl lightControl5(
  "NEMA_0002",
  "NEMA_0002",
  "control light",
  "NEMA_0002",
  "NEMA_0002",
  "NEMA_0002",
  "70"
);

int counterDummySendMqtt = 0;

void taskDummySendMqtt(void *pvParameter)
{
  while (true)
  {
    if (counterDummySendMqtt == 10)
    {
      counterDummySendMqtt = 0;
    }
    else
    {
      counterDummySendMqtt ++;
    }

    if (counterDummySendMqtt == 0)
    {
      publishData(MQTT_FEED_POLE_02, lightControl.genStringFromJson());
    }
    else if (counterDummySendMqtt == 3)
    {
      publishData(MQTT_FEED_POLE_02, lightControl2.genStringFromJson());      
      
    }
    else if (counterDummySendMqtt == 5)
    {
      publishData(MQTT_FEED_POLE_02, lightControl3.genStringFromJson());      
    }
    else if (counterDummySendMqtt == 7)
    {
      publishData(MQTT_FEED_POLE_02, lightControl4.genStringFromJson());
    }
    else if (counterDummySendMqtt == 9)
    {
      publishData(MQTT_FEED_POLE_02, lightControl5.genStringFromJson());
    }


    if (counterDummySendMqtt == 10)
    {
      counterDummySendMqtt = 0;
    }
    else
    {
      counterDummySendMqtt ++;
    }

    printlnData(MQTT_FEED_NOTHING, String(counterDummySendMqtt));

    vTaskDelay(pdMS_TO_TICKS(delay_lora_dummy_send));
  }
}

int counter = 100;
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