#include <M5Atom.h>
#include <ACmearsureHelper.h>
#include <wifi_setup.h>
#include <MQTT_helper.h>
#include <ArduinoJson.h>

Wifi_esp32 atom_wifi(
    "RD-SEAI_2.4G",
    ""
);

MyMQTT atom_MQTT(
    "mqtt.ohstem.vn",
    "BK_SmartPole",
    ""
);

String ON_Json()
{
    JsonDocument doc;
    doc["station_id"] = "SmartPole_0002";
    doc["station_name"] = "Smart Pole 0002";
    doc["action"] = "control light";
    doc["device_id"] = "NEMA_0002";
    doc["data"] = "62";

    String jsonString;
    serializeJson(doc, jsonString);
    // Serial.println("Data to pub:");
    // serializeJsonPretty(doc, Serial);
    doc.clear();
    Serial.println();
    return jsonString;
}

String OFF_Json()
{
    JsonDocument doc;
    doc["station_id"] = "SmartPole_0002";
    doc["station_name"] = "Smart Pole 0002";
    doc["action"] = "control light";
    doc["device_id"] = "NEMA_0002";
    doc["data"] = "0";

    String jsonString;
    serializeJson(doc, jsonString);
    // Serial.println("Data to pub:");
    // serializeJsonPretty(doc, Serial);
    doc.clear();
    Serial.println();
    return jsonString;
}

void setup()
{
    Serial.begin(115200);
    M5.begin(true, false, false);
    while (!(sensor.begin(&Wire, UNIT_ACMEASURE_ADDR, 26, 32, 100000UL)))
    {
        Serial.println("No module!");
    }
    Serial.println("ACmeasure sensor is ready!");
    xTaskCreate(updateACinfor, "", 4096, NULL, 0, NULL);
    atom_wifi.setupWifi();
    atom_MQTT.connectToMQTT();
}

void loop()
{
    // updateACinfor();
    if (voltage > 200)
    {
        Serial.println("Have person!");
        String message = ON_Json();
        atom_MQTT.publish("BK_SmartPole/feeds/V20", message);
    }
    else if (voltage < 100)
    {
        Serial.println("Empty!");
        String message = ON_Json();
        atom_MQTT.publish("BK_SmartPole/feeds/V20", message);
    }
    else
    {
        Serial.println("Unknown!");
    }

    delay(1000);
}