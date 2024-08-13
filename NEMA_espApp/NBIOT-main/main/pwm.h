/*
 * pwm.h
 *
 *  Created on: 4 thg 12, 2023
 *      Author: JACKWR
 */

#ifndef MAIN_PWM_H_
#define MAIN_PWM_H_

#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "driver/ledc.h"
#include "esp_err.h"


// The GPIO for LED is default set to GPIO_5

void pwm_init();
void pwm_set_duty(int duty);


#endif /* MAIN_PWM_H_ */
