import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'mqtt_helper.dart';


// For declaring global variables
bool USE_BORDER_RADIUS = false;
// bool USE_BORDER_RADIUS = true;

const String MQTT_SERVER = "mqtt.ohstem.vn";
const String MQTT_USERNAME = "BK_SmartPole";
const String MQTT_PASSWORD = " ";
const String MQTT_TOPIC = "BK_SmartPole/feeds/V20";
const SENSOR_DATA_URL = "https://ezdata2.m5stack.com/api/v2/4827E2E30938/dataMacByKey/raw";
const DATABASE_URL = "https://nema-nbiot-controller-default-rtdb.asia-southeast1.firebasedatabase.app/";

late MQTTHelper global_mqttHelper;
late DatabaseReference global_databaseReference;

//Colors constants
//Blue colors
Color BLUE_COLOR_1 = const Color(0xFF1E88E5);
Color BLUE_COLOR_2 = const Color(0xFF1488D8);

//White colors
Color WHITE_COLOR_1 = const Color(0xFFF9F9F9);

//Primary colors
Color PRIMARY_WHITE_COLOR = WHITE_COLOR_1;
Color PRIMARY_BLUE_COLOR = BLUE_COLOR_2;
Color PRIMARY_BLACK_COLOR = Colors.black;
Color PRIMARY_PAGE_BORDER_COLOR = const Color(0xFFE6E5F2);
Color PRIMARY_PANEL_COLOR = const Color(0xFF7A40F2);