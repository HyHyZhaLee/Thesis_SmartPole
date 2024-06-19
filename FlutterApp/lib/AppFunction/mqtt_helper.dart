import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Import kIsWeb
import 'dart:convert'; // For JSON decoding

class MQTTHelper {
  late MqttServerClient _client;
  final String _server;
  final String _clientIdentifier;
  final String _username;
  final String _password;
  bool _useWebSocket;
  int _port;
  // Add a callback function
  Function? onConnectedCallback;

  // Constructor with _useWebSocket as an optional parameter, default is false, port default is 1883
  MQTTHelper(this._server, this._clientIdentifier, this._username, this._password, [this._port = 0, this._useWebSocket = false]) {
    // Check if the build platform is web or android/ios
    if (kIsWeb) {
      _useWebSocket = true;
      if (_port == 0) {
        _port = 8084;
      }
    } else {
      _useWebSocket = false;
      if (_port == 0) {
        _port = 1883;
      }
    }
  }

  Future<bool> initializeMQTTClient() async {
    _client = MqttServerClient(_server, _clientIdentifier);
    _client.port = _port; // Use the appropriate port based on the platform
    _client.useWebSocket = _useWebSocket;
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

  void subscribe(String topic, [Function(String topic, dynamic message)? onMessage]) {
    _client.subscribe(topic, MqttQos.atLeastOnce);
    _client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print('Received message from topic "${c[0].topic}":\n "$payload"');
      if (onMessage != null) {
        onMessage(topic, payload); // Call the provided onMessage function
      }
    });
  }

  // Callbacks
  void _onConnected() {
    print('Connected to MQTT Broker as $_clientIdentifier');
    if (onConnectedCallback != null) {
      onConnectedCallback!();
    }
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
