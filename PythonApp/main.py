import datetime
from IO_interacting.MQTT_Helper import *
from IO_interacting.Physic import *
import firebase_admin
from firebase_admin import credentials


cred = credentials.Certificate("nema-nbiot-controller-firebase-adminsdk-aebc8-4148185772.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://nema-nbiot-controller-default-rtdb.firebaseio.com/'
})


# Define for MQTT server
MQTT_SERVER = "mqtt.ohstem.vn"
MQTT_USERNAME = "BK_SmartPole"
MQTT_PASSWORD = " "
CLIENT_ID = "BK_SmartPole " + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S %Z%z")
TOPIC =  "BK_SmartPole/feeds/V15"

if __name__ == '__main__':
    # physic = Physic(False)  # Initialize the class with debug mode enabled
    mqtt_helper = MQTTClientHelper(MQTT_SERVER, MQTT_USERNAME, MQTT_PASSWORD, CLIENT_ID)
    mqtt_helper.connect()
    mqtt_helper.subscribe(TOPIC)
    while True:
        pass
    # Test sequence for actuators and sensors
    # while True:
    #     # Read all sensors
    #     for sensor in physic.RS485_sensors_format.keys():
    #         if sensor == "ambient_light_high" or sensor == "ambient_light_low":
    #             pass  # Skip these value
    #         else:
    #             value = physic.readSensors(sensor)
    #             print(f"Sensor {sensor}: {value}")
    #     time.sleep(5)  # Pause before the next read sequence
