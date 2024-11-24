#include "light_control.h"

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

