#include "device_init.h"

void device_init()
{
  xTaskCreate(task_pwm_light_control_init, "taskPWMLightControl", 4096, NULL, 1, NULL);
  xTaskCreate(taskLedBlink, "taskLedBlink", 4096, NULL, 1, NULL); 
}