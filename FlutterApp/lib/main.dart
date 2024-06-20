import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';
import 'AppFunction/mqtt_manager.dart';
import 'Widgets/custom_slider_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _brightness = 0;
  double _brightness2 = 0; // Slider value for second device
  bool _isLightOn = false;
  String _statusMessage = 'Disconnected';

  @override
  void initState() {
    super.initState();
    MqttManager(); // Initialize MQTT Manager
  }

  void _updateBrightness(double value, String deviceID) {
    // Update the brightness value
    double brightness = 0.0;
    if (deviceID == "NEMA_0002") {
      _brightness = value;
      brightness = _brightness;
    } else if (deviceID == "NEMA_0003") {
      _brightness2 = value;
      brightness = _brightness2;
    }

    // Setting the message to be sent to the MQTT server
    var message = jsonEncode({
      "station_id": "SmartPole_0002",
      "station_name": "Smart Pole 0002",
      "action": "control light",
      "device_id": deviceID,
      "data": brightness.round().toString()
    });

    // Publish the message to the MQTT server
    global_mqttHelper.publish(MQTT_TOPIC, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1488DB), // Set the AppBar background color
        titleTextStyle: const TextStyle(
          color: Colors.white, // Set the title text color to white
          fontSize: 24, // Increase the font size for better visibility
          fontWeight: FontWeight.bold, // Make the title bold
        ),
        elevation: 4, // Optional: Adds shadow below the AppBar
        centerTitle: true, // Optional: Centers the title
        title: const Text('Smart Pole Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: CustomSliderWidget(
                      initialSliderValue: _brightness,
                      onValueChanged: (value) {
                        _updateBrightness(value, "NEMA_0002");  // Updates for device NEMA_0002
                      },
                      deviceName: "NEMA 0002",
                    ),
                  ),
                  Expanded(
                    child: CustomSliderWidget(
                      initialSliderValue: _brightness2,
                      onValueChanged: (value) {
                        _updateBrightness(value, "NEMA_0003");  // Updates for device NEMA_0003
                      },
                      deviceName: "NEMA 0003",
                    ),
                  ),
                ],
              ),
            ),
            // Additional controls can be placed here if needed
          ],
        ),
      ),
    );
  }
}
