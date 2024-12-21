#include "on_off_json.h"

String on_off_json(bool mode)
{
  String jsonString;    
  JsonDocument doc;

  if (mode == ON_JSON)
  {
    doc["station_id"] = "SmartPole_0002";
    doc["station_name"] = "Smart Pole 0002";
    doc["action"] = "control light";
    doc["device_id"] = "NEMA_0002";
    doc["data"] = "30";
  } 
  else
  {
    doc["station_id"] = "SmartPole_0002";
    doc["station_name"] = "Smart Pole 0002";
    doc["action"] = "control light";
    doc["device_id"] = "NEMA_0002";
    doc["data"] = "0";
  }

  printlnData(MQTT_FEED_NOTHING, " ");

  serializeJson(doc, jsonString);
  doc.clear();

  return jsonString;
}
