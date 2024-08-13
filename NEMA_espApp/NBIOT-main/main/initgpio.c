/*
 * initgpio.c
 *
 *  Created on: 24 thg 4, 2024
 *      Author: JACKWR
 */


#include "initgpio.h"

int led_status = 0;

void power_init(void){
	gpio_config_t io_conf;
	io_conf.pin_bit_mask = 1<< POWER;							//*** config GPIO
	io_conf.mode = GPIO_MODE_OUTPUT;
	io_conf.pull_up_en = 1;
	io_conf.pull_down_en = 0;
	io_conf.intr_type = GPIO_INTR_DISABLE;							// vo hieu hoa interrupt
	gpio_config(&io_conf);
}



void uart_init(bool PRODUCT) {
    const uart_config_t uart_config = {
        .baud_rate = 115200,
        .data_bits = UART_DATA_8_BITS,
        .parity = UART_PARITY_DISABLE,
        .stop_bits = UART_STOP_BITS_1,
        .flow_ctrl = UART_HW_FLOWCTRL_DISABLE,
        .source_clk = UART_SCLK_DEFAULT,
    };
    // We won't use a buffer for sending data.
    uart_driver_install(UART_DRIVER, RX_BUF_SIZE * 2, 0, 0, NULL, 0);
    uart_param_config(UART_DRIVER, &uart_config);


    if (PRODUCT)
    	// USING THIS FOR OFFICIAL PRODUCT
    	uart_set_pin(UART_DRIVER, TXD_PIN_BOOT, RXD_PIN_BOOT, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);
    else
    	// For UART1_16_17: USING FOR TESTING PROTOTYPE
    	uart_set_pin(UART_DRIVER, TXD_PIN_U2, RXD_PIN_U2, UART_PIN_NO_CHANGE, UART_PIN_NO_CHANGE);

}


void led_init(void){
	gpio_config_t io_conf;
	io_conf.pin_bit_mask = 1<< GPIO_NUM_2;							//*** config GPIO
	io_conf.mode = GPIO_MODE_OUTPUT;
	io_conf.pull_up_en = 0;
	io_conf.pull_down_en = 1;
	io_conf.intr_type = GPIO_INTR_DISABLE;							// vo hieu hoa interrupt
	gpio_config(&io_conf);
}



void relay_init(void){
	gpio_config_t io_conf;
	io_conf.pin_bit_mask = 1<< GPIO_NUM_18;							//*** config GPIO
	io_conf.mode = GPIO_MODE_OUTPUT;
	io_conf.pull_up_en = 0;
	io_conf.pull_down_en = 1;
	io_conf.intr_type = GPIO_INTR_DISABLE;							// vo hieu hoa interrupt
	gpio_config(&io_conf);
}





