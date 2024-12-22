import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/util/smart_device_box.dart';
import 'package:flutter_app/util/sensor_data_box.dart';
import 'package:flutter_app/AppFunction/mqtt_helper.dart';
import 'dart:convert';

const MQTT_SERVER = "mqtt.ohstem.vn";
const MQTT_PORT = 8084;
const MQTT_USERNAME = "BK_SmartPole";
const MQTT_PASSWORD = "";
const MQTT_CONTROL_LIGHT_TOPIC = "BK_SmartPole/feeds/V20";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MQTTHelper mqttHelper;
  String _statusMessage = 'Disconnected';
  List<Map<String, String>> mySensors = [];

  @override
  void initState() {
    super.initState();
    mqttHelper = MQTTHelper(MQTT_SERVER, 'SmartPole_0002', MQTT_USERNAME, MQTT_PASSWORD);
    initializeMQTT();
  }

  Future<void> initializeMQTT() async {
    bool isConnected = await mqttHelper.initializeMQTTClient();
    if (isConnected) {
      mqttHelper.subscribe(MQTT_CONTROL_LIGHT_TOPIC, handleReceivedMessage);
      setState(() {
        _statusMessage = 'Connected';
      });
    } else {
      setState(() {
        _statusMessage = 'Connection Failed';
      });
    }
  }

  void handleReceivedMessage(dynamic message) {
    print("Handling message: $message");
    try {
      Map<String, dynamic> msg = jsonDecode(message);
      if (msg['station_id'] == 'SmartPole_0002' &&
          msg['station_name'] == 'Smart Pole 0002' &&
          msg['action'] == 'control light') {
        // Handle specific logic here based on the message
        print("Control light action received: ${msg['data']}");
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

  List mySmartDevices = [
    ["NEMA_0002", "lib/icons/light-bulb.png", false],
    ["NEMA_0003", "lib/icons/light-bulb.png", false],
  ];

  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
      String deviceId = mySmartDevices[index][0];

      // Prepare the message structure as per the new MQTT topic
      var message = jsonEncode({
        "station_id": "SmartPole_0002",
        "station_name": "Smart Pole 0002",
        "action": "control light",
        "device_id": "NEMA_0002",
        "data": {
          "from": "NEMA_0002",
          "to": deviceId, // Example target device
          "dimming": value ? "70" : "0", // Adjust dimming based on the switch
        }
      });

      mqttHelper.publish(MQTT_CONTROL_LIGHT_TOPIC, message);
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
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
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
              padding: const EdgeInsets.symmetric(horizontal: 40),
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
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(thickness: 1, color: Color.fromARGB(255, 204, 204, 204)),
            ),
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
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
                    physics: const NeverScrollableScrollPhysics(),
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
