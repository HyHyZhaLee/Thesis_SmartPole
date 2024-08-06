#include <task.h>

#define TIME_DEBOUNCING_FACTOR    5

MyMQTT atom_MQTT(
    "mqtt.ohstem.vn",
    "BK_SmartPole",
    ""
);

int8_t setValuePublish = LOW;
int8_t prevStatusPublish = setValuePublish;
int8_t currStatusPublish = setValuePublish;

int8_t setPinValue = HIGH;
int8_t prevPinValue = setPinValue;
int8_t currPinValue = setPinValue;
int8_t timerPinValueDebouncingFactor = TIME_DEBOUNCING_FACTOR;


String feedPole_01 = "BK_SmartPole/feeds/V20";

void taskHandlePoleControl (void* pvParameters)
{
  while (1)
  {
    currPinValue = digitalRead(32);
    // Serial.println(currPinValue);
    // Serial.println(timerPinValueDebouncingFactor);
    if (currPinValue == prevPinValue)
    {
      timerPinValueDebouncingFactor --; 
      if (timerPinValueDebouncingFactor <= 0)
      {
        setValuePublish = currPinValue;
        prevPinValue = currPinValue;
        timerPinValueDebouncingFactor = TIME_DEBOUNCING_FACTOR;
      }
    }
    else
    {
      prevPinValue = currPinValue;
      timerPinValueDebouncingFactor = TIME_DEBOUNCING_FACTOR;
    }
    // timerWrite(timer, 0);
    vTaskDelay(23);
  }
}

void taskPublish2Server(void* pvParameter)
{
  while (1)
  {
    timerWrite(timer, 0);
    atom_MQTT.checkConnect();
    currStatusPublish = setValuePublish;
    if (currStatusPublish != prevStatusPublish)
    {
      prevStatusPublish = currStatusPublish;
      Serial.println(prevStatusPublish + "Status Publish");
      if (currStatusPublish == LOW)
      {
        String message = ON_Json();
        atom_MQTT.publish(feedPole_01, message);
      }
      else
      {
        String message = OFF_Json();
        atom_MQTT.publish(feedPole_01, message);
      }
    }
    vTaskDelay(499);
  }
}