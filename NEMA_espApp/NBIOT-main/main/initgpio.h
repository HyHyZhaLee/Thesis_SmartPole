/*
 * initgpio.h
 *
 *  Created on: 24 thg 4, 2024
 *      Author: JACKWR
 */

#ifndef MAIN_INITGPIO_H_
#define MAIN_INITGPIO_H_

#include "esp_system.h"
#include "driver/uart.h"
#include "pwm.h"


#define TXD_PIN_U2 (GPIO_NUM_17)				// Using it for "Prototype"
#define RXD_PIN_U2 (GPIO_NUM_16)
#define TXD_PIN_BOOT (GPIO_NUM_1)				// Using it for "MAIN PRODUCT"
#define RXD_PIN_BOOT (GPIO_NUM_3)
#define UART_DRIVER UART_NUM_1

#define POWER GPIO_NUM_4
#define RELAY GPIO_NUM_18
#define RX_BUF_SIZE  512


extern int led_status;


void uart_init(bool);
void power_init(void);
void led_init(void);
void relay_init(void);








#endif /* MAIN_INITGPIO_H_ */
