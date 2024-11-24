// DEFINE DEBUG MODE
#define _DEBUG_MODE_
#define _IS_DEBUG_MODE_ true
// #define _IS_DEBUG_MODE_ false


// DEFINE PIN


// DEFINE LED
#define INBUILD_LED_PIN  2
#define LED_ON           HIGH
#define LED_OFF          LOW

// DEFINE LORA
#define UART_LORA_TXD_PIN           3
#define UART_LORA_RXD_PIN           1
#define UART_LORA_RXD_DEBUG_PIN     16
#define UART_LORA_TXD_DEBUG_PIN     17
#define TIME_CONFIGURE_PROCESS      1*1000
#define TIME_LORA_RECV_PROCESS      10

// DEFINE MQTT 
#define MQTT_MAX_PACKAGE_SIZE        1024

#define MQTT_SERVER     "mqtt.ohstem.vn"
#define MQTT_PORT       1883
#define MQTT_USERS      "BK_SmartPole"
#define MQTT_PASSWORD   " "

#define MQTT_FEED_NOTHING           ""
#define MQTT_FEED_01                "BK_SmartPole/feeds/V20"
#define MQTT_FEED_TEST_LORA         "BK_SmartPole/feeds/V5"
#define MQTT_FEED_TEST_LORA_SEND    "BK_SmartPole/feeds/V4"
#define MQTT_FEED_TEST_MQTT         "BK_SmartPole/feeds/V3"
#define MQTT_FEED_TEST_LORA_RECV    "BK_SmartPole/feeds/V2"
#define MQTT_FEED_TEST_DIMMING      "BK_SmartPole/Feeds/V1"


// DEFINE WIFI AP
#define WIFI_SSID         "RD-SEAI_2.4G"
#define WIFI_PASS         ""

// DEFINE DIMMING PWM
#define PWM_CHANNEL       0
#define PWM_FREQ          5000  // PWM frequency in Hz
#define PWM_RESOLUTION    13  // PWM resolution in bits
#define PWM_PIN           5

// DEFINE DELAY
#define delay_for_initialization        10*1000
#define delay_test_dimming              1000
#define delay_wifi                      3600*1000
#define delay_connect                   100
#define delay_mqtt                      7000
#define delay_send_message              60003
#define delay_lora_configure            10*1000
#define delay_led_blink                 1000
#define delay_rev_lora_process          1
#define delay_send_lora_process         10*1000

// DEFINE RELAY
#define RELAY_PIN   18

// DEFINE JSON MODE
#define ON_JSON     1
#define OFF_JSON    0