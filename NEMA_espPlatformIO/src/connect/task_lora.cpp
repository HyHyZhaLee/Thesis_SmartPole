#include "task_lora.h"

LoRa_E220_JP lora;
struct LoRaConfigItem_t config;
struct RecvFrame_t data;

int timer_configure = TIME_CONFIGURE_PROCESS;
String message;

String textBuffer;
bool isConfgured = false;

bool loraSend(String message)
{
  if (lora.SendFrame(config, (uint8_t *)(message.c_str()), message.length()) == 0) {
    printlnData(MQTT_FEED_TEST_LORA_SEND, "Send successfully: " + message);
    return true;
  } 
  else 
  {
    printlnData(MQTT_FEED_TEST_LORA_SEND, "Send failed");
    return false;
  }
}


void taskLoraInit(void *pvParameters)
{
  // Initialize Serial communication
  lora.SetDefaultConfigValue(config);

  // Set initial configuration values
  config.own_address              = 0x0002;
  config.baud_rate                = BAUD_9600;
  config.air_data_rate            = BW125K_SF9;
  config.subpacket_size           = SUBPACKET_200_BYTE;
  config.rssi_ambient_noise_flag  = RSSI_AMBIENT_NOISE_ENABLE;
  config.transmitting_power       = TX_POWER_13dBm;
  config.own_channel              = 0x00;
  config.rssi_byte_flag           = RSSI_BYTE_ENABLE;
  config.transmission_method_type = UART_P2P_MODE;
  config.lbt_flag                 = LBT_DISABLE;
  config.wor_cycle                = WOR_2000MS;
  config.encryption_key           = 0x1234;
  config.target_address           = 0xFFFF;
  config.target_channel           = 0x00;

  // Initialize LoRa communication
 

  int initResult;
  int initAttempts = 0;
  const int maxInitAttempts = 3;

  if (lora.InitLoRaSetting(config) != 0) 
  {
    printlnData(MQTT_FEED_TEST_LORA, "Lora init failed! ");
    while (lora.InitLoRaSetting(config)!= 0)
    {
      vTaskDelay(delay_lora_configure);
    }
  }
  printlnData(MQTT_FEED_TEST_LORA, "Lora init success! ");
  
  vTaskDelete(NULL);
}

void taskLoraRecv (void* pvParameters)
{
  vTaskDelay(delay_for_initialization);
  while (true)
  {
    if (lora.RecieveFrame(&data) == 0)
    {
      textBuffer = "";
      for (int i = 0; i < data.recv_data_len; i++) {
        textBuffer += (char)data.recv_data[i];
      }
      lora_buffer.push_back(textBuffer);
    }
    vTaskDelay(delay_rev_lora_process);
  }
}

void taskLoraSend(void* pvParameters)
{
  
  vTaskDelay(delay_for_initialization);
  String msg = "Hello, world!";
  while (true)
  {
    loraSend(msg);
    vTaskDelay(delay_lora_configure);
  }
}



void loraInit(void *pvParameters)
{
  xTaskCreate(taskLoraInit, "Recv_Lora", 4096, NULL,1, NULL);
}