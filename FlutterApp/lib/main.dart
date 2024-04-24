import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'mqtt_helper.dart';

String mqtt_server = "io.adafruit.com";
String mqtt_cliend_id = "Flutter_app";
String mqtt_user_name = "AI_ProjectHGL" ;
String mqtt_password = "aio_" + "rdVf662waw2mFNqq427hAJLxsDRn";

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
      home: const MyHomePage(title: 'Flutter MQTT Home Page'),
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
  int _counter = 10;
  late MQTTHelper _mqttHelper;

  @override
  void initState() {
    super.initState();
    _mqttHelper = MQTTHelper(mqtt_server, mqtt_cliend_id, mqtt_user_name, mqtt_password);
    _initializeMQTT();
  }

  void _initializeMQTT() async {
    await _mqttHelper.initializeMQTTClient();
    _mqttHelper.subscribe('AI_ProjectHGL/feeds/pole');
    _mqttHelper.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);

      setState(() {
        _counter = int.tryParse(payload) ?? _counter; // Update counter based on received payload
      });
    });
  }


  @override
  void dispose() {
    _mqttHelper.disconnect();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _mqttHelper.publish('AI_ProjectHGL/feeds/pole', _counter.toString()); // Gửi giá trị hiện tại của counter
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
