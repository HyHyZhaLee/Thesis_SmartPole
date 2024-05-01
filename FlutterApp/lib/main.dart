import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:convert'; // To use jsonEncode and jsonDecode
import 'AppFunction/mqtt_helper.dart';
import 'Widgets/custom_slider_widget.dart';

// Your MQTT details
String mqttServer = "mqttserver.tk";
String mqttClientId = "Flutter_app";
String mqttUserName = "innovation";
String mqttPassword = "Innovation_RgPQAZoA5N";
String mqttTopic = "/innovation/airmonitoring/SmartPole";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter MQTT Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'MQTT Light Control'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late MQTTHelper _mqttHelper;
  double _brightness = 0;
  double _brightness2 = 0; // Slider value for second device
  bool _isLightOn = false;
  String _statusMessage = 'Disconnected';

  @override
  void initState() {
    super.initState();
    _mqttHelper = MQTTHelper(mqttServer, mqttClientId, mqttUserName, mqttPassword);
    _initializeMQTT();
  }

  void _initializeMQTT() async {
    bool isConnected = await _mqttHelper.initializeMQTTClient();
    if (isConnected) {
      _mqttHelper.subscribe(mqttTopic, _handleReceivedMessage);
      setState(() {
        _statusMessage = 'Connected';
      });
    } else {
      setState(() {
        _statusMessage = 'Connection Failed';
      });
    }
  }

  void _handleReceivedMessage(dynamic message) {
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

  void _publishControlMessage(double brightness, String deviceId) {
    var message = jsonEncode({
      "station_id": "SmartPole_0002",
      "station_name": "Smart Pole 0002",
      "action": "control light",
      "device_id": deviceId,
      "data": brightness.round().toString()
    });
    _mqttHelper.publish(mqttTopic, message);
  }

  void _updateBrightness(double brightness, String deviceId) {
    setState(() {
      if (deviceId == "NEMA_0002") {
        _brightness = brightness;
      } else if (deviceId == "NEMA_0003") {
        _brightness2 = brightness;
      }
      _isLightOn = brightness > 0;
    });
    _publishControlMessage(brightness, deviceId);
  }

  @override
  void dispose() {
    _mqttHelper.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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
