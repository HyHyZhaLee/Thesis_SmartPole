import paho.mqtt.client as mqtt
import time
import json

class MQTTClientHelper:
    def __init__(self, broker_host, username, password, client_id):
        """Initialize the MQTT client with broker details and user credentials."""
        self.broker_host = broker_host  # Address of the MQTT broker
        self.broker_port = 1883  # Default MQTT broker port
        self.username = username  # Username for broker authentication
        self.password = password  # Password for broker authentication
        self.client_id = client_id  # Unique ID for the MQTT client
        self.client = mqtt.Client(client_id)  # Create the MQTT client
        self.client.username_pw_set(username, password)  # Set credentials
        self.client.on_connect = self.on_connect  # Assign connect event handler
        self.client.on_message = self.on_message  # Assign message event handler

    def on_connect(self, client, userdata, flags, rc):
        """Callback for when the client receives a CONNECT response from the server."""
        if rc == 0:
            print("Connected to MQTT Broker")
        else:
            print("Connection failed with code", rc)

    def on_message(self, client, userdata, msg):
        """Callback for when a PUBLISH message is received from the server."""
        try:
            payload = json.loads(msg.payload.decode())  # Decode JSON payload
            print(f"Received message on topic {msg.topic}: {payload}")
            # Handle the received payload as needed
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON: {e}")

    def connect(self):
        """Connect to the MQTT broker and start the network loop."""
        self.client.connect(self.broker_host, self.broker_port)
        self.client.loop_start()  # Start the loop to process callbacks

    def subscribe(self, topic):
        """Subscribe to a specific topic to listen for messages."""
        self.client.subscribe(topic)
        print(f"Subscribed to topic: {topic}")

    def publish(self, topic, payload):
        """Publish a message (payload) to a specific topic."""
        try:
            payload_str = json.dumps(payload)  # Encode payload as JSON
            self.client.publish(topic, payload_str)
            print(f"Published to topic {topic}: {payload}")
        except json.JSONDecodeError as e:
            print(f"Error encoding JSON: {e}")

    def disconnect(self):
        """Disconnect from the MQTT broker and stop the network loop."""
        self.client.disconnect()
        self.client.loop_stop()  # Stop the loop
        print("Disconnected from MQTT Broker")

# Example usage:
if __name__ == "__main__":
    broker_host = "io.adafruit.com"
    username = "your_adafruit_username"
    password = "your_adafruit_aio_key"
    client_id = "your_unique_client_id"

    mqtt_helper = MQTTClientHelper(broker_host, username, password, client_id)
    mqtt_helper.connect()  # Connect to the broker

    # Subscribe to a topic
    topic_to_subscribe = f"{username}/feeds/your_feed_name"
    mqtt_helper.subscribe(topic_to_subscribe)

    # Publish a message
    topic_to_publish = f"{username}/feeds/your_feed_name"
    message_to_publish = {"key": "value"}
    mqtt_helper.publish(topic_to_publish, message_to_publish)

    # Keep the program running to listen for messages
    while True:
        pass