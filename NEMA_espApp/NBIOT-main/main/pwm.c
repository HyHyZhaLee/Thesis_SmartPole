/*
 * pwm.c
 *
 *  Created on: 4 thg 12, 2023
 *      Author: JACKWR
 */

#include "pwm.h"


void pwm_init(){
	ledc_timer_config_t ledc_timer = {
	        .duty_resolution = LEDC_TIMER_13_BIT, // resolution of PWM duty
	        .freq_hz = 5000,                      // frequency of PWM signal
	        .speed_mode = LEDC_LOW_SPEED_MODE,           // timer mode
	        .timer_num = LEDC_TIMER_0,            // timer index
	        .clk_cfg = LEDC_CHANNEL_0,              // Auto select the source clock
	};

	ESP_ERROR_CHECK(ledc_timer_config(&ledc_timer));


	ledc_channel_config_t ledc_channel = {
	        .speed_mode     = LEDC_LOW_SPEED_MODE,
	        .channel        = LEDC_CHANNEL_0,
	        .timer_sel      = LEDC_TIMER_0,
	        .intr_type      = LEDC_INTR_DISABLE,
	        .gpio_num       = 5,
	        .duty           = 0, // Set duty to 0%
	        .hpoint         = 0
	};
	ESP_ERROR_CHECK(ledc_channel_config(&ledc_channel));


	ledc_fade_func_install(0);

}


void pwm_set_duty(int duty){

	duty = duty * 8192 / 100;


	ledc_set_fade_with_time(LEDC_LOW_SPEED_MODE,
			LEDC_CHANNEL_0, duty, 500);


	ledc_fade_start(LEDC_LOW_SPEED_MODE,
			LEDC_CHANNEL_0, LEDC_FADE_WAIT_DONE);

}


