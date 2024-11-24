#ifndef GLOBAL_H
#define GLOBAL_H

#include <Wire.h>
#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include <M5_LoRa_E220_JP.h>
#include <Preferences.h>

// include common files
#include "../src/common/defines.h"

// include connect 
#include "../src/connect/connect_init.h"

// include task
#include "../src/task/task_init.h"

// include json file
#include "../src/utils/on_off_json.h"
#include "../src/utils/serial_print.h"
#include "../src/utils/light_control.h"

#endif /* GLOBAL_H */