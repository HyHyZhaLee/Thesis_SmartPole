#include <M5Atom.h>
#include <wifi_setup.h>
#include <MQTT_helper.h>

#include <JsonHelper.h>
#include <task.h>
#include <Watch_dog.h>

Wifi_esp32 atom_wifi(
    "ACLAB",
    "ACLAB2023"
);


void setup()
{
  Serial.begin(115200);
  M5.begin(true, false, false);
  Serial.println("ATOM is ready");

  atom_wifi.setupWifi();
  atom_MQTT.connectToMQTT();

  pinMode(32, INPUT_PULLUP);

  // pinMode(26, OUTPUT);
  // digitalWrite(32, HIGH);
  WatchdogInit();

  xTaskCreate(taskHandlePoleControl, "", 4096, NULL, 0, NULL);
  xTaskCreate(taskPublish2Server, "", 4096, NULL, 0, NULL);
}

void loop()
{

}