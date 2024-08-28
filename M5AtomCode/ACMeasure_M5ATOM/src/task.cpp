#include <task.h>
#include <MQTT_helper.h>

MyMQTT atom_MQTT(
    "mqtt.ohstem.vn",
    "BK_SmartPole",
    " "
);

int8_t state_pole = INIT_STATE;
int8_t prevStatusPublish = TURN_OFF_SIGNAL;
int8_t currStatusPublish = TURN_OFF_SIGNAL;

int8_t oldPinValue = TURN_OFF_SIGNAL;
int8_t prevPinValue = TURN_OFF_SIGNAL;
int8_t prev2PinValue = TURN_OFF_SIGNAL;
int8_t currPinValue = TURN_OFF_SIGNAL;

int16_t timerTurnOffLightFactor = TIME_DELAY_TURN_OFF_FACTOR;

bool turn_flag = false;
bool prev_turn_flag = false;


bool blink_flag = false;
int led_color = WHITE;

bool MQTT_disconnect_flag = false;

String feedPole_01 = "BK_SmartPole/feeds/V20";

void taskLedBlink (void* pvParameters)
{
  while (1)
  {
    led_color = (pvParameters != NULL) 
              ? (*(int *) pvParameters) 
              : (WHITE);
    if (blink_flag)
      M5.dis.drawpix(0, BLACK); 
    else
      M5.dis.drawpix(0, led_color);
    blink_flag = !blink_flag;
    vTaskDelay(1999);
  }
}

void taskHandleControlFlag (void* pvParameters)
{
  while (1)
  {
    prev2PinValue = prevPinValue;
    prevPinValue = currPinValue;
    currPinValue = digitalRead(INPUT_PIN);
  
    if (prev2PinValue == prevPinValue && prevPinValue == currPinValue)
    {
      if (currPinValue == TURN_ON_SIGNAL) 
      {
        turn_flag = true;

        oldPinValue = currPinValue;
      }
      else 
      {
        if (oldPinValue != currPinValue)
        {
          timerTurnOffLightFactor = TIME_DELAY_TURN_OFF_FACTOR;
          oldPinValue = currPinValue;
        }
        else
        {
          timerTurnOffLightFactor--;
          if (timerTurnOffLightFactor <= 0)
          {
            turn_flag = false;
            timerTurnOffLightFactor = TIME_DELAY_TURN_OFF_FACTOR;
          }
        }
      }
    }
    vTaskDelay(19);
  }
}

void taskPublish2Server(void* pvParameter)
{
  while (1)
  {
    timerWrite(timer, 0);
    atom_MQTT.checkConnect();
    switch (state_pole)
    {
    case INIT_STATE:
      state_pole = DONT_HAVE_PERSON;

      turn_flag = false;
      led_color = RED;
      break;
    case HAVE_PERSON:

      if (MQTT_disconnect_flag)
      {
        String message = ON_Json();
        atom_MQTT.publish(feedPole_01, message);
        MQTT_disconnect_flag = false;
      }

      if (turn_flag == false)
      {
        led_color = RED;
        state_pole = DONT_HAVE_PERSON;

        String message = OFF_Json();
        atom_MQTT.publish(feedPole_01, message); // led blue
      }
      else if (turn_flag == true)
      {

      }
      break;

    case DONT_HAVE_PERSON:

      if (MQTT_disconnect_flag)
      {
        String message = OFF_Json();
        atom_MQTT.publish(feedPole_01, message);
        MQTT_disconnect_flag = false;
      }

      if (turn_flag == true)
      {
        led_color = GREEN;
        state_pole = HAVE_PERSON;

        String message = ON_Json();
        atom_MQTT.publish(feedPole_01, message); // led green
      }
      else if (turn_flag == false)
      {

      }
      break;
    default:
      state_pole = INIT_STATE;
      break;
    }
    vTaskDelay(499);
  }
}