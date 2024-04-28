import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert'; // For JSON decoding

class MQTTHelper {
  late MqttServerClient _client;
  final String _server;
  final String _clientIdentifier;
  final String _username;
  final String _password;

  MQTTHelper(this._server, this._clientIdentifier, this._username, this._password);

  Future<bool> initializeMQTTClient() async {
    _client = MqttServerClient(_server, _clientIdentifier);
    _client.port = 1883; // Default port for MQTT
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
      print('MQTT Connection Exception: $e');
      _client.disconnect();
      return false;
    }

    if (_client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT Client Connected');
      return true;
    } else {
      print('ERROR: MQTT client connection failed - disconnecting, status is ${_client.connectionStatus}');
      _client.disconnect();
      return false;
    }
  }

  void disconnect() {
    _client.disconnect();
    print('MQTT Client Disconnected');
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload!, retain: true);
    print('Message published to $topic');
  }

  void subscribe(String topic, Function(dynamic message) onMessage) {
    _client.subscribe(topic, MqttQos.atLeastOnce);
    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received message: $payload from topic: ${c[0].topic}');
      try {
        var decodedMessage = jsonDecode(payload);
        onMessage(decodedMessage); // Callback for processing received message
      } catch (e) {
        print('Error in decoding JSON: $e');
      }
    });
  }

  // Callbacks
  void _onConnected() {
    print('Connected to MQTT Broker as $_clientIdentifier');
  }

  void _onDisconnected() {
    if (_client.connectionStatus!.disconnectionOrigin == MqttDisconnectionOrigin.solicited) {
      print('Disconnected from MQTT Broker');
    } else {
      print('Lost connection to MQTT Broker - attempting to reconnect');
      initializeMQTTClient(); // Attempt to reconnect
    }
  }

  void _onSubscribed(String topic) {
    print('Subscribed to topic: $topic');
  }
}
