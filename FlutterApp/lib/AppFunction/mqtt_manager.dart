import 'dart:convert';
import 'package:flutter/material.dart';
import 'mqtt_helper.dart';
import 'global_variables.dart';

class MqttManager {
  /* MQTT information:
    MQTT_PORT_FOR_ANDROID = 1883
    MQTT_PORT_FOR_WEB = 8084
    MQTT_SERVER = "mqtt.ohstem.vn"
    MQTT_USERNAME = "BK_SmartPole"
    MQTT_PASSWORD = " "
    MQTT_TOPIC = "BK_SmartPole/feeds/V20"
 */

  MqttManager() {
    global_mqttHelper = MQTTHelper(MQTT_SERVER, "SmartPole_0002", MQTT_USERNAME, MQTT_PASSWORD);
    global_mqttHelper.onConnectedCallback = () {
      print("MQTT Connected");
      global_mqttHelper.subscribe(MQTT_TOPIC, _handleReceivedMessage);
    };
    global_mqttHelper.initializeMQTTClient();
  }

  void _handleReceivedMessage(String topic, dynamic message) {
    // TODO: Handle received message
  }
}
