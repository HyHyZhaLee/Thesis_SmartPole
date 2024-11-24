#include "task_pwm_light_control.h"

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
}

void task_pwm_light_control(void* pvParameters)
{
  pwm_init();

  while(true)
  {
    vTaskDelay(pdMS_TO_TICKS(5001));
  }
}