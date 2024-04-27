import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'mqtt_helper.dart';
import 'dart:convert';  // Add this to use jsonEncode

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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

  @override
  void initState() {
    super.initState();
    _mqttHelper = MQTTHelper(mqttServer, mqttClientId, mqttUserName, mqttPassword);
    _initializeMQTT();
  }

  void _initializeMQTT() async {
    await _mqttHelper.initializeMQTTClient();
    _mqttHelper.subscribe(mqttTopic);
    _mqttHelper.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
      final brightnessValue = double.tryParse(payload) ?? _brightness;
      setState(() {
        _brightness = brightnessValue;
        _isLightOn = _brightness > 0;
      });
    });
  }

  void _publishControlMessage(double brightness) {
    // Create the JSON data structure
    var message = jsonEncode({
      "station_id": "SmartPole_0002",
      "station_name": "Smart Pole 0002",
      "action": "control light",
      "device_id": "NEMA_0002",
      "data": brightness.round().toString()
    });
    _mqttHelper.publish(mqttTopic, message);  // Publish JSON as a string
  }

  void _updateBrightness(double brightness) {
    setState(() {
      _brightness = brightness;
      _isLightOn = brightness > 0;
    });
    _publishControlMessage(_brightness);  // Update to send JSON message
  }

  void _toggleLight(bool isOn) {
    setState(() {
      _isLightOn = isOn;
      _brightness = isOn ? 100 : 0;
    });
    _publishControlMessage(_brightness);  // Update to send JSON message
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
            ListTile(
              title: Text('Light Brightness'),
              trailing: Switch(
                value: _isLightOn,
                onChanged: _toggleLight,
              ),
            ),
            Slider(
              value: _brightness,
              onChanged: _updateBrightness,
              min: 0,
              max: 100,
              divisions: 100,
              label: '${_brightness.round()}',
            ),
            // Add more device controls here
          ],
        ),
      ),
      // Add more functionality or navigation if needed
    );
  }
}
