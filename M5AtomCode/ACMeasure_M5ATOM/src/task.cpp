#include <task.h>

MyMQTT atom_MQTT(
    "mqtt.ohstem.vn",
    "BK_SmartPole",
    " "
);

int8_t state_pole = INIT_STATE;
int8_t prevStatusPublish = TURN_OFF_SIGNAL;
int8_t currStatusPublish = TURN_OFF_SIGNAL;

int8_t oldPinValue = TURN_OFF_SIGNAL;
int8_t prevPinValue = oldPinValue;
int8_t prev2PinValue = oldPinValue;
int8_t currPinValue = oldPinValue;

int16_t timerTurnOffLightFactor = TIME_DELAY_TURN_OFF_FACTOR;

bool turn_flag = false;
bool prev_turn_flag = false;
bool blink_flag = false;

String feedPole_01 = "BK_SmartPole/feeds/V20";

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
          }
        }
      }
    }
    vTaskDelay(23);
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
      break;
    case HAVE_PERSON:
      if (blink_flag == false)
      {
        M5.dis.drawpix(0, BLACK);
        blink_flag = true;
      }
      else
      {
        M5.dis.drawpix(0, GREEN);
        blink_flag = false;
      }


      if (turn_flag == false)
      {
        state_pole = DONT_HAVE_PERSON;

        String message = OFF_Json();
        atom_MQTT.publish(feedPole_01, message); // led blue
      }
      else if (turn_flag == true)
      {

      }
      break;

    case DONT_HAVE_PERSON:

      if (blink_flag == false)
      {
        M5.dis.drawpix(0, BLACK);
        blink_flag = true;
      }
      else
      {
        M5.dis.drawpix(0, BLUE);
        blink_flag = false;
      }

      if (turn_flag == true)
      {
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