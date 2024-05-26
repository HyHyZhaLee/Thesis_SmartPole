import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/util/smart_device_box.dart';
import 'package:flutter_app/util/sensor_data_box.dart';
import 'package:flutter_app/AppFunction/mqtt_helper.dart';
import 'dart:convert'; // For JSON decoding

const MQTT_SERVER = "mqttserver.tk";
const MQTT_PORT = 1883;
const MQTT_USERNAME = "innovation";
const MQTT_PASSWORD = "Innovation_RgPQAZoA5N";
const MQTT_TOPIC = "/innovation/airmonitoring/SmartPole";

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

  @override
  void initState() {
    super.initState();
    mqttHelper = MQTTHelper(MQTT_SERVER, 'SmartPole_0002', MQTT_USERNAME, MQTT_PASSWORD);
    initializeMQTT();
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

  void handleReceivedMessage(dynamic message) {
    print("Handling message: $message");
    try {
      // Decode the message into a map
      Map<String, dynamic> msg = jsonDecode(message);
      // Check the contents of the message before proceeding
      if (msg['station_id'] == 'SmartPole_0002' &&
          msg['station_name'] == 'Smart Pole 0002' &&
          msg['action'] == 'control light') {
        // Safely try to parse the brightness value
        double brightnessValue = double.tryParse(msg['data'].toString()) ?? _brightness;
        setState(() {
          _brightness = brightnessValue;
          _isLightOn = _brightness > 0;  // Update the light state based on brightness
          print("Brightness setting: $brightnessValue");
        });
      } else {
        print("Message does not match required criteria.");
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

  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // list of smart devices
  List mySmartDevices = [
    // [ smartDeviceName, iconPath , powerStatus ]
    ["NEMA 0001", "lib/icons/light-bulb.png", false],
    ["NEMA 0002", "lib/icons/light-bulb.png", false],
  ];

  // list of sensor data
  List mySensors = [
    // Image path: svgrepo.com; thickness = 45%
    // [ sensorName, iconPath , sensorData ]
    ["Temperature", "lib/icons/temperature.png", "22°C"],
    ["Humidity", "lib/icons/humidity.png", "54%"],
    ["PM1.0", "lib/icons/pm1_0.png", "25 µg/m³"],
    ["PM2.5", "lib/icons/pm25.png", "15 µg/m³"],
    ["PM4.0", "lib/icons/pm40.png", "12 µg/m³"],
    ["PM10", "lib/icons/pm10.png", "10 µg/m³"],
    ["CO2", "lib/icons/co2.png", "450 ppm"],
  ];

  // power button switched
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;

      // Publish message to MQTT
      final message = jsonEncode({
        "station_id": "SmartPole_0002",
        "station_name": "Smart Pole 0002",
        "action": "control light",
        "device_id": mySmartDevices[index][0],
        "data": value ? 80 : 0 // Assuming 80 is the brightness level
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
            // app bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menu icon
                  Image.asset(
                    'lib/icons/menu.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),
                  // account icon
                  Image.asset(
                    'lib/icons/Logo-DH-Bach-Khoa-HCMUT.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // welcome home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Capstone Project",
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                  Text(
                    'SMART POLE',
                    style: GoogleFonts.bebasNeue(fontSize: 72),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),
            SizedBox(height: 25),
            // smart devices grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Smart Devices",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            SizedBox(height: 10),
            // smart devices grid and sensor data grid combined
            LayoutBuilder(
              builder: (context, constraints) {
                int itemCount = mySmartDevices.length + mySensors.length;
                int rowCount = (itemCount / 2).ceil();
                double height = rowCount * 250; // Adjust based on your item height

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
                          sensorName: mySensors[sensorIndex][0],
                          iconPath: mySensors[sensorIndex][1],
                          sensorData: mySensors[sensorIndex][2],
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
