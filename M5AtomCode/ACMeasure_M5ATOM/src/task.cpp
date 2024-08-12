#include <task.h>

#define TIME_DEBOUNCING_FACTOR          5
#define TIME_DELAY_TURN_OFF_FACTOR      250

#define TURN_ON_SIGNAL                  LOW
#define TURN_OFF_SIGNAL                 HIGH

#define INIT_STATE                      0
#define HAVE_PERSON                     1
#define DONT_HAVE_PERSON                2



MyMQTT atom_MQTT(
    "mqtt.ohstem.vn",
    "BK_SmartPole",
    " "
);

int8_t state_pole = INIT_STATE;

int8_t setValuePublish = TURN_OFF_SIGNAL;
int8_t prevStatusPublish = setValuePublish;
int8_t currStatusPublish = setValuePublish;

int8_t oldPinValue = TURN_OFF_SIGNAL;
int8_t prevPinValue = oldPinValue;
int8_t prev2PinValue = oldPinValue;
int8_t currPinValue = oldPinValue;

int16_t timerTurnOffLightFactor = TIME_DELAY_TURN_OFF_FACTOR;
bool turn_flag = false;
bool prev_turn_flag = false;

String feedPole_01 = "BK_SmartPole/feeds/V20";

void taskHandleControlFlag (void* pvParameters)
{
  while (1)
  {
    prev2PinValue = prevPinValue;
    prevPinValue = currPinValue;
    currPinValue = digitalRead(32);
  
    if (prev2PinValue == prevPinValue && prevPinValue == currPinValue)
    {
      if (currPinValue == TURN_ON_SIGNAL) 
      {
        turn_flag = true;

        oldPinValue = currPinValue;

        setValuePublish = TURN_ON_SIGNAL;
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

            setValuePublish = TURN_OFF_SIGNAL;
          }
        }
      }
    }
    vTaskDelay(23);
  }
  
}

void taskHandlePoleControl (void* pvParameters)
{
  while (1)
  {
    // switch (state_pole)
    // {
    // case INIT_STATE:
    //   state_pole = DONT_HAVE_PERSON;

    //   turn_flag = false;
    //   break;
    //   case HAVE_PERSON:

    //   if (turn_flag == false)
    //   {
    //     state_pole = DONT_HAVE_PERSON;

    //     String message = OFF_Json();
    //     atom_MQTT.publish(feedPole_01, message);
    //     M5.dis.drawpix(0, 0x0000f0); // led blue
    //   }
    //   else if (turn_flag == true)
    //   {

    //   }
    //   break;

    //   case DONT_HAVE_PERSON:

    //   if (turn_flag == true)
    //   {
    //     state_pole = HAVE_PERSON;

    //     String message = OFF_Json();
    //     atom_MQTT.publish(feedPole_01, message);
    //     M5.dis.drawpix(0, 0x00ff00);
    //   }
    //   else if (turn_flag == false)
    //   {

    //   }
    //   break;

    // default:
    //   state_pole = INIT_STATE;
    //   break;
    // }


    // if (turn_flag != prev_turn_flag)
    // {
    //   Serial.println(turn_flag);
    //   prev_turn_flag = turn_flag;
    //   if (turn_flag == false)
    //   {
    //     timerTurnOffLightFactor = TIME_DELAY_TURN_OFF_FACTOR;
    //   }
    //   else
    //   {
    //     setValuePublish = TURN_ON_SIGNAL;
    //     timerTurnOffLightFactor = TIME_DELAY_TURN_OFF_FACTOR;
    //   }
    // }
    // else
    // {
    //   if (turn_flag == false)
    //   {
    //     timerTurnOffLightFactor --;
    //     if (timerTurnOffLightFactor <= 0)
    //     {
    //       setValuePublish = TURN_OFF_SIGNAL;
    //       timerTurnOffLightFactor = TIME_DELAY_TURN_OFF_FACTOR;
    //     }
    //   }
    // }
    // vTaskDelay(19);
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
      // Serial.println(prevStatusPublish + "Status Publish");
      if (currStatusPublish == TURN_ON_SIGNAL)
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