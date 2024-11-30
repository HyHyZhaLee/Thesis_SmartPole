#include "task_pwm_nema.h"

void pwm_init()
{
  // Configure LEDC Timer
  ledcSetup(LEDC_CHANEL, FREQ_HZ, RESOLUTION);

  // Attach the channel to the GPIO to be controlled
  ledcAttachPin(POLE_LED_PIN, LEDC_CHANEL);

  // Initialize fade service for smooth fading
  ledcWrite(LEDC_CHANEL, INIT_DUTY_PWM);
}

void pwm_set_duty(int dutyPercent)
{
  int duty =  (MAX_DUTY_PWM * dutyPercent) / 100;

  ledcWrite(LEDC_CHANEL, dutyPercent);
  ledcWriteTone(LEDC_CHANEL, duty);

  printData(MQTT_FEED_NOTHING, "PWM set duty " + duty);
}

void task_pwm_light_control_init(void* pvParameters)
{
  pwm_init();

  vTaskDelete(NULL);
}