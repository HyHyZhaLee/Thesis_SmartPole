import 'mqtt_helper.dart';


// For declaring global variables
const String MQTT_SERVER = "mqtt.ohstem.vn";
const String MQTT_USERNAME = "BK_SmartPole";
const String MQTT_PASSWORD = " ";
const String MQTT_TOPIC = "BK_SmartPole/feeds/V20";
const SENSOR_DATA_URL = "https://ezdata2.m5stack.com/api/v2/4827E2E30938/dataMacByKey/raw";

late MQTTHelper global_mqttHelper;
