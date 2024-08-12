#include <main.h>

Wifi_esp32 atom_wifi(
    "BK_SMART_POLE_STATION",
    "ACLAB2023"
);

void setup()
{
  Serial.begin(115200);
  M5.begin(true, false, true);
  Serial.println("ATOM is ready");

  atom_wifi.setupWifi();
  atom_MQTT.connectToMQTT();

  pinMode(32, INPUT_PULLUP);

  // pinMode(26, OUTPUT);
  // digitalWrite(32, HIGH);
  WatchdogInit();
  atom_MQTT.publish(feedPole_01, OFF_Json());

  xTaskCreate(taskHandlePoleControl, "", 4096, NULL, 1, NULL);
  xTaskCreate(taskHandleControlFlag, "", 4096, NULL, 1, NULL);
  xTaskCreate(taskPublish2Server, "", 4096, NULL, 1, NULL);
}

void loop()
{

}