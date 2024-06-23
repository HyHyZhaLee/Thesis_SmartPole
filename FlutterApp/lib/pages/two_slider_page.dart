import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';
import 'package:flutter_app/Widgets/custom_slider_widget.dart';

import '../AppFunction/global_helper_function.dart';

class TwoSliderPage extends StatefulWidget {
  const TwoSliderPage({Key? key}) : super(key: key);

  @override
  _TwoSliderPageState createState() => _TwoSliderPageState();
}

class _TwoSliderPageState extends State<TwoSliderPage> {
  late double _brightness = 0;
  late double _brightness2 = 0; // Slider value for second device
  bool _isLightOn = false;
  String _statusMessage = 'Disconnected';

  @override
  void initState() {
    super.initState();
    _loadInitialBrightness();
  }

  Future<void> _loadInitialBrightness() async {
    try {
      // Get the initial brightness value from the database
      DatabaseEvent event1 = await global_databaseReference.child("NEMA_0002").child("Newest data").once();
      DatabaseEvent event2 = await global_databaseReference.child("NEMA_0003").child("Newest data").once();

      if (event1.snapshot.value != null && event1.snapshot.value is Map) {
        final data1 = event1.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _brightness = (data1['brightness'] ?? 0).toDouble();
        });
        print('Initial brightness for NEMA_0002: $_brightness');
      }
      if (event2.snapshot.value != null && event2.snapshot.value is Map) {
        final data2 = event2.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _brightness2 = (data2['brightness'] ?? 0).toDouble();
        });
        print('Initial brightness for NEMA_0003: $_brightness2');
      }
    } catch (e) {
      print('Failed to load initial brightness: $e');
    }
  }

  void _publishBrightness(double value, String deviceID) {
    setState(() {
      // Update the brightness value
      if (deviceID == "NEMA_0002") {
        _brightness = value;
      } else if (deviceID == "NEMA_0003") {
        _brightness2 = value;
      }
    });

    double brightness = (deviceID == "NEMA_0002") ? _brightness : _brightness2;

    // Setting the message to be sent to the MQTT server
    var message = jsonEncode({
      "station_id": "SmartPole_0002",
      "station_name": "Smart Pole 0002",
      "timestamp": getCurrentTimestamp(),
      "action": "control light",
      "device_id": deviceID,
      "data": brightness.round().toString()
    });

    // Publish the message to the MQTT server
    global_mqttHelper.publish(MQTT_TOPIC, message);

    // Update the brightness value in the database
    global_databaseReference.child(deviceID).child("Newest data").set({
      "brightness": brightness.round(),
      "timestamp": getCurrentTimestamp(),
    });
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
                        _publishBrightness(value, "NEMA_0002");  // Updates for device NEMA_0002
                      },
                      deviceName: "NEMA 0002",
                    ),
                  ),
                  Expanded(
                    child: CustomSliderWidget(
                      initialSliderValue: _brightness2,
                      onValueChanged: (value) {
                        _publishBrightness(value, "NEMA_0003");  // Updates for device NEMA_0003
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
