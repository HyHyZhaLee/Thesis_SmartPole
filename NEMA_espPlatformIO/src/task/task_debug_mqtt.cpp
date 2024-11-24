#include "task_debug_mqtt.h"

void taskDebugMQTT(void* pvParameters)
{
  String message = "Still connected ";

  while (true )
  {
    printlnData(MQTT_FEED_TEST_MQTT, message);
    vTaskDelay(delay_send_message / portTICK_PERIOD_MS); 
  }
  
}