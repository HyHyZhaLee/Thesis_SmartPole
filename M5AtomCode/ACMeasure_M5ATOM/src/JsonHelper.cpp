#include <JsonHelper.h>

String ON_Json()
{
    JsonDocument doc;
    // doc["station_id"] = "SmartPole_0002";
    // doc["station_name"] = "Smart Pole 0002";
    // doc["action"] = "update data";
    // doc["device_id"] = "CT01_0002";
    // doc["data"] = "1";

    doc["station_id"] = "SmartPole_0002";
    doc["station_name"] = "Smart Pole 0002";
    doc["action"] = "control light";
    doc["device_id"] = "NEMA_0002";
    doc["data"] = "10";

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
    // doc["station_id"] = "SmartPole_0002";
    // doc["station_name"] = "Smart Pole 0002";
    // doc["action"] = "update data";
    // doc["device_id"] = "CT01_0002";
    // doc["data"] = "0";

    doc["station_id"] = "SmartPole_0002";
    doc["station_name"] = "Smart Pole 0002";
    doc["action"] = "control light";
    doc["device_id"] = "NEMA_0002";
    doc["data"] = "0";

    String jsonString;
    serializeJson(doc, jsonString);
    doc.clear();
    Serial.println();
    return jsonString;
}