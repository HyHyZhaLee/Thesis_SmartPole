import 'package:firebase_database/firebase_database.dart';

import 'mqtt_helper.dart';


// For declaring global variables
const String MQTT_SERVER = "mqtt.ohstem.vn";
const String MQTT_USERNAME = "BK_SmartPole";
const String MQTT_PASSWORD = " ";
const String MQTT_TOPIC = "BK_SmartPole/feeds/V20";
const SENSOR_DATA_URL = "https://ezdata2.m5stack.com/api/v2/4827E2E30938/dataMacByKey/raw";
const DATABASE_URL = "https://nema-nbiot-controller-default-rtdb.asia-southeast1.firebasedatabase.app/";

late MQTTHelper global_mqttHelper;
late DatabaseReference global_databaseReference;