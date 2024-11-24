#include "light_control.h"

// Constructor function for LightControl
LightControl::LightControl(DynamicJsonDocument &document)
{
  station_id = document["station_id"].as<String>();
  station_name = document["station_name"].as<String>();
  action = document["action"].as<String>();
  device_id = document["device_id"].as<String>();

  if (document.containsKey("data") && document["data"].is<JsonObject()>())
  {
    JsonObject data = document["data"].as<JsonObject>();
    from = data["from"].as<String>();
    to = data["to"].as<String>();
    dimming = data["dimming"].as<String>();
  }
}

String LightControl :: createMQTTLightControlTopic(){
  DynamicJsonDocument doc(1024);

  doc["station_id"] = station_id;
  doc["station_name"] = station_name;
  doc["action"] = action;
  doc["device_id"] = device_id;


  JsonArray data = doc.createNestedArray("data");
  doc["from"] = from;
  doc["to"] = to;
  doc["dimming"] = dimming;

  String jsonString;
  serializeJson(doc, jsonString);
  Serial.println("Data to pub:");
  // serializeJsonPretty(doc, Serial);
  doc.clear();
  Serial.println();
  return jsonString;
}

void LightControl :: publish(String feedName){
  String message = createMQTTLightControlTopic();

  publishData(feedName, message);
}

void LightControl :: controlLight()
{
  
}

