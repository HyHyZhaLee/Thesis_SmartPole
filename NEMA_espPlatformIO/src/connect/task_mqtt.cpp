#include "task_mqtt.h"

String user = MQTT_USERS;
String password = MQTT_PASSWORD;

WiFiClient espClient;
PubSubClient client(espClient);

void callback(char *topic, byte *payload, unsigned int length)
{
  printData(MQTT_FEED_NOTHING, "Message arrived [");
  printData(MQTT_FEED_NOTHING, topic);
  printData(MQTT_FEED_NOTHING, "] ");
  printlnData(MQTT_FEED_NOTHING, " ");
  String pload = "";
  for (int i = 0; i < length; i++) 
  {
    pload += (char)payload[i];
  }
  printlnData(MQTT_FEED_NOTHING, pload);

  // STORE BUFFER
  mqttBuffer.push_back(pload);
}

bool publishData(String feedName, String message)
{
  String topic = feedName;
  #ifdef ADAFRUIT
    String topic = user + "/feeds/" + feedName;
  #endif
  printData(MQTT_FEED_NOTHING, "Publishing to topic: ");
  printData(MQTT_FEED_NOTHING, feedName + " ");
  printData(MQTT_FEED_NOTHING, "Status: ");

  if(client.publish(topic.c_str(), message.c_str(),1)){
    printlnData(MQTT_FEED_NOTHING, "Success!: " + message);
    return 1;
  }
  printlnData(MQTT_FEED_NOTHING, "Failed!: " + message);
  return 0;
}

void reconnectMQTT()
{
  while (!client.connected())
  {
    printlnData(MQTT_FEED_NOTHING, "Connecting to MQTT...");

    String clientId = "ESP32Client" + String(random(0, 1000));
    if (client.connect(clientId.c_str(), user.c_str(), password.c_str()))
    { 
      printlnData(MQTT_FEED_NOTHING, "MQTT Connected");
      
      // Subscribe to topic put in here
      #ifdef _ESP_NUMBER_ONE_
        client.subscribe(MQTT_FEED_POLE_02);
      #endif
      // client.subscribe((String(IO_USERNAME) + "/feeds/relay").c_str());
      // client.subscribe((String(IO_USERNAME) + "/feeds/schedule").c_str());

      // String data = "{\"email\":\"" + String(EMAIL) + "\",\"data\":\"" + WiFi.localIP().toString() + "\"}";
      // publishData("ip", data);

      printlnData(MQTT_FEED_NOTHING, "Start");
    }
    else
    {
      printData(MQTT_FEED_NOTHING, "MQTT connection failed, rc=");
      printlnData(MQTT_FEED_NOTHING, String(client.state()));
    }
    vTaskDelay(5000 / portTICK_PERIOD_MS);
  }
}

void taskMQTT(void *pvParameters)
{
  while (WiFi.status() != WL_CONNECTED)
  {
    vTaskDelay(delay_connect / portTICK_PERIOD_MS);
  }

  client.setServer(MQTT_SERVER, MQTT_PORT);
  client.setCallback(callback);
  
  #ifdef _ESP_NUMBER_ONE_
    client.subscribe(MQTT_FEED_POLE_02);
  #endif

  while (true)
  {
    if (!client.connected())
    {
      reconnectMQTT();
    }

    client.loop();
    vTaskDelay(delay_mqtt / portTICK_PERIOD_MS);
  }
}

void mqtt_init()
{
  xTaskCreate(taskMQTT, "TaskMQTT", 4096, NULL, 1, NULL);
}