#include "globals.h"


void setup() {
  if (_IS_DEBUG_MODE_)
  {
    Serial.begin(115200);
    lora.Init(&Serial2, 9600, SERIAL_8N1, UART_LORA_RXD_DEBUG_PIN, UART_LORA_TXD_DEBUG_PIN);
  }
  else
  {
    Serial.begin(115200);
    lora.Init(&Serial1, 9600, SERIAL_8N1, UART_LORA_TXD_PIN, UART_LORA_RXD_PIN);
  }


  delay(delay_for_initialization);
  connect_init();
  device_init();
  task_init();
}

void loop() {
  // put your main code here, to run repeatedly:
}
