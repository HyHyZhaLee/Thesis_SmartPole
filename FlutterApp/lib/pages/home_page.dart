import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/util/smart_device_box.dart';
import 'package:flutter_app/util/sensor_data_box.dart';
import 'package:flutter_app/AppFunction/mqtt_helper.dart';
import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

const MQTT_SERVER = "mqttserver.tk";
const MQTT_PORT = 1883;
const MQTT_USERNAME = "innovation";
const MQTT_PASSWORD = "Innovation_RgPQAZoA5N";
const MQTT_TOPIC = "/innovation/airmonitoring/SmartPole";
const SENSOR_DATA_URL = "https://ezdata2.m5stack.com/api/v2/4827E2E30938/dataMacByKey/raw";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MQTTHelper mqttHelper;
  String _statusMessage = 'Disconnected';
  double _brightness = 0;
  bool _isLightOn = false;

  List<Map<String, String>> mySensors = [];

  @override
  void initState() {
    super.initState();
    mqttHelper = MQTTHelper(MQTT_SERVER, 'SmartPole_0002', MQTT_USERNAME, MQTT_PASSWORD);
    initializeMQTT();
    fetchSensorData();
  }

  Future<void> initializeMQTT() async {
    bool isConnected = await mqttHelper.initializeMQTTClient();
    if (isConnected) {
      mqttHelper.subscribe(MQTT_TOPIC, handleReceivedMessage);
      setState(() {
        _statusMessage = 'Connected';
      });
    } else {
      setState(() {
        _statusMessage = 'Connection Failed';
      });
    }
  }

  Future<void> fetchSensorData() async {
    try {
      final response = await http.get(Uri.parse(SENSOR_DATA_URL));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final sensorDataRaw = data['data']['value'];
        final sensorData = json.decode(sensorDataRaw.replaceAll(r'\"', '"'));
        setState(() {
          mySensors = [
            {"sensorName": "Temperature", "iconPath": "lib/icons/temperature.png", "sensorData": "${sensorData['sen55']['temperature'].toStringAsFixed(2)}°C"},
            {"sensorName": "Humidity", "iconPath": "lib/icons/humidity.png", "sensorData": "${sensorData['sen55']['humidity'].toStringAsFixed(2)}%"},
            {"sensorName": "PM1.0", "iconPath": "lib/icons/pm1_0.png", "sensorData": "${sensorData['sen55']['pm1.0'].toStringAsFixed(2)} µg/m³"},
            {"sensorName": "PM2.5", "iconPath": "lib/icons/pm25.png", "sensorData": "${sensorData['sen55']['pm2.5'].toStringAsFixed(2)} µg/m³"},
            {"sensorName": "PM4.0", "iconPath": "lib/icons/pm40.png", "sensorData": "${sensorData['sen55']['pm4.0'].toStringAsFixed(2)} µg/m³"},
            {"sensorName": "PM10", "iconPath": "lib/icons/pm10.png", "sensorData": "${sensorData['sen55']['pm10.0'].toStringAsFixed(2)} µg/m³"},
            {"sensorName": "CO2", "iconPath": "lib/icons/co2.png", "sensorData": "${sensorData['scd40']['co2']} ppm"},
          ];
        });
      } else {
        throw Exception('Failed to load sensor data');
      }
    } catch (e) {
      print('Failed to fetch sensor data: $e');
    }
  }

  void handleReceivedMessage(dynamic message) {
    print("Handling message: $message");
    try {
      Map<String, dynamic> msg = jsonDecode(message);
      if (msg['station_id'] == 'SmartPole_0002' &&
          msg['station_name'] == 'Smart Pole 0002' &&
          msg['action'] == 'control light') {
        double brightnessValue = double.tryParse(msg['data'].toString()) ?? _brightness;
        setState(() {
          _brightness = brightnessValue;
          _isLightOn = _brightness > 0;
        });
      }
    } catch (e) {
      print('Error processing received message: $e');
    }
  }

  @override
  void dispose() {
    mqttHelper.disconnect();
    super.dispose();
  }

  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  List mySmartDevices = [
    ["NEMA 0001", "lib/icons/light-bulb.png", false],
    ["NEMA 0002", "lib/icons/light-bulb.png", false],
  ];

  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
      String deviceId = mySmartDevices[index][0];
      if(deviceId == "NEMA 0001") {
        deviceId = "NEMA_0001";
      } else if(deviceId == "NEMA 0002") {
        deviceId = "NEMA_0002";
      }
      var message = jsonEncode({
        "station_id": "SmartPole_0002",
        "station_name": "Smart Pole 0002",
        "action": "control light",
        "device_id": deviceId,
        "data": value ? "90" : "0"
      });
      mqttHelper.publish(MQTT_TOPIC, message);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('lib/icons/menu.png', height: 45, color: Colors.grey[800]),
                  Image.asset('lib/icons/Logo-DH-Bach-Khoa-HCMUT.png', height: 45),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Capstone Project", style: TextStyle(fontSize: 20, color: Colors.grey.shade800)),
                  Text('SMART POLE', style: GoogleFonts.bebasNeue(fontSize: 72)),
                ],
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(thickness: 1, color: Color.fromARGB(255, 204, 204, 204)),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text("Smart Devices", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.grey.shade800)),
            ),
            SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                int itemCount = mySmartDevices.length + mySensors.length;
                int rowCount = (itemCount / 2).ceil();
                double height = rowCount * 250;

                return SizedBox(
                  height: height,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: itemCount,
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.3,
                    ),
                    itemBuilder: (context, index) {
                      if (index < mySmartDevices.length) {
                        return SmartDeviceBox(
                          smartDeviceName: mySmartDevices[index][0],
                          iconPath: mySmartDevices[index][1],
                          powerOn: mySmartDevices[index][2],
                          onChanged: (value) => powerSwitchChanged(value, index),
                        );
                      } else {
                        int sensorIndex = index - mySmartDevices.length;
                        return SensorDataBox(
                          sensorName: mySensors[sensorIndex]["sensorName"]!,
                          iconPath: mySensors[sensorIndex]["iconPath"]!,
                          sensorData: mySensors[sensorIndex]["sensorData"]!,
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
