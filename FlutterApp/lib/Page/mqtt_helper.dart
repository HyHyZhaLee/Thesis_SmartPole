import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MQTTHelper {
  late MqttServerClient _client;
  final String _server;
  final String _clientIdentifier;
  final String _username;
  final String _password;

  MQTTHelper(this._server, this._clientIdentifier, this._username, this._password);

  Future<void> initializeMQTTClient() async {
    _client = MqttServerClient(_server, _clientIdentifier);
    _client.port = 1883;
    _client.keepAlivePeriod = 60;
    _client.onDisconnected = _onDisconnected;
    _client.onConnected = _onConnected;
    _client.onSubscribed = _onSubscribed;

    _client.secure = false;
    _client.setProtocolV311();
    _client.logging(on: true);
    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(_clientIdentifier)
        .authenticateAs(_username, _password)
        .startClean();

    try {
      await _client.connect();
    } catch (e) {
      print('Exception: $e');
      _client.disconnect();
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT Client Connected');
    } else {
      print('ERROR: MQTT client connection failed - disconnecting, status is ${_client.connectionStatus}');
      _client.disconnect();
    }
  }

  void disconnect() {
    _client.disconnect();
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!);
  }

  void subscribe(String topic) {
    _client.subscribe(topic, MqttQos.atLeastOnce);
  }

  Stream<List<MqttReceivedMessage<MqttMessage>>> get updates => _client.updates!;

  void _onConnected() {
    print('Connected to MQTT Broker');
  }

  void _onDisconnected() {
    print('Disconnected from MQTT Broker');
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }
}
