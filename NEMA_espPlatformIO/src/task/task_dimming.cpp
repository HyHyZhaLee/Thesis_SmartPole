#include "task_dimming.h"

int duty = 0;
bool counting_mode = false; // 0 is up, 1 is down

void setupPWM(int pin) {
  ledcSetup(PWM_CHANNEL, PWM_FREQ, PWM_RESOLUTION);
  ledcAttachPin(pin, PWM_CHANNEL);
}

void DimmingLight(int dutyCycle) {
  if (dutyCycle == 0) {
    digitalWrite(RELAY_PIN, LOW);  // Turn off the relay
  } else if (dutyCycle == 100) {
    digitalWrite(RELAY_PIN, HIGH);  // Turn on the relay
  }


  printData(MQTT_FEED_NOTHING, "DIMMING");
  printlnData(MQTT_FEED_NOTHING, String(dutyCycle));

  // Calculate the duty cycle for PWM resolution
  int pwmDuty = map(dutyCycle, 0, 100, 0, 255);
  ledcWrite(PWM_CHANNEL, pwmDuty);
}

void taskTestDimming(void *pvParameters)
{
  setupPWM(PWM_PIN);
  pinMode(RELAY_PIN, OUTPUT);

  while(true)
  {
    if (counting_mode == false) {
      duty ++;
      if (duty >= 100)
      {
        counting_mode = true;

      }
      DimmingLight(duty);
    } 
    else //counting_mode == true
    {
      duty --;
      if (duty <= 0)
      {
        counting_mode = false;

      }
      DimmingLight(duty);
    } 
    vTaskDelay(delay_test_dimming / portTICK_PERIOD_MS); 
  }

// Delete the task when done
}