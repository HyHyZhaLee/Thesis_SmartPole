import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'AppFunction/mqtt_helper.dart';
import 'dart:convert';  // To use jsonEncode and jsonDecode
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
      double brightnessValue = double.tryParse(message['data'].toString()) ?? _brightness;
      setState(() {
        _brightness = brightnessValue;
        _isLightOn = _brightness > 0;
        print("Brightness setting: $brightnessValue");
      });
    } catch (e) {
      print('Error processing received message: $e');
    }
  }

  void _publishControlMessage(double brightness) {
    var message = jsonEncode({
      "station_id": "SmartPole_0002",
      "station_name": "Smart Pole 0002",
      "action": "control light",
      "device_id": "NEMA_0002",
      "data": brightness.round().toString()
    });
    _mqttHelper.publish(mqttTopic, message);
  }

  void _updateBrightness(double brightness) {
    setState(() {
      _brightness = brightness;
      _isLightOn = brightness > 0;
    });
    _publishControlMessage(_brightness);
  }

  void _toggleLight(bool isOn) {
    setState(() {
      _isLightOn = isOn;
      _brightness = isOn ? 100 : 0;
    });
    _publishControlMessage(_brightness);
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
              child: CustomSliderWidget(
                initialSliderValue: _brightness,
                onValueChanged: (value) {
                  _updateBrightness(value);
                },
              ),
            ),
            // Add more device controls here
          ],
        ),
      ),
      // Add more functionality or navigation if needed
    );
  }
}
