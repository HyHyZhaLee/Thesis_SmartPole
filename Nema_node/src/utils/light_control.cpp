#include "light_control.h"

// Constructor function for LightControl

LightControl :: LightControl(String strJson)
{
  if (strJson[0] != '{' && strJson.endsWith("}"))
  {
    printData(MQTT_FEED_NOTHING , "Initial Light Control invalid");
    return;
  }
  DynamicJsonDocument document(1024);
  deserializeJson(document, strJson);
  station_id = document["station_id"].as<String>();
  station_name = document["station_name"].as<String>();
  action = document["action"].as<String>();
  device_id = document["device_id"].as<String>();

  if (document["data"].is<JsonObject>()) {
    JsonObject data = document["data"].as<JsonObject>();
    from = data["from"].as<String>();
    to = data["to"].as<String>();
    dimming = data["dimming"].as<String>();
  }

  document.clear();
}
LightControl :: LightControl(DynamicJsonDocument &document)
{
  station_id = document["station_id"].as<String>();
  station_name = document["station_name"].as<String>();
  action = document["action"].as<String>();
  device_id = document["device_id"].as<String>();

  if (document["data"].is<JsonObject>()) {
    JsonObject data = document["data"].as<JsonObject>();
    from = data["from"].as<String>();
    to = data["to"].as<String>();
    dimming = data["dimming"].as<String>();
  }
}

String LightControl :: genStringFromJson(){
  DynamicJsonDocument doc(1024);

  doc["station_id"] = station_id;
  doc["station_name"] = station_name;
  doc["action"] = action;
  doc["device_id"] = device_id;


  // JsonArray data = doc.createNestedArray("data");
  JsonObject dataJson = doc.createNestedObject("data");
  dataJson["from"] = from;
  dataJson["to"] = to;
  dataJson["dimming"] = dimming;

  String jsonString;
  serializeJson(doc, jsonString);
  doc.clear();
  return jsonString;
}

// void LightControl :: publish(String feedName){
//   String message = genStringFromJson();

//   publishData(feedName, message);
// }


