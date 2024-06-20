import 'package:flutter/material.dart';
import 'AppFunction/mqtt_manager.dart';
import 'pages/two_slider_page.dart';  // Import the new file

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    MqttManager(); // Initialize MQTT Manager
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TwoSliderPage(),
    );
  }
}
