import sys
import time

from AI_Detection.opencv.detect import *
from IO_interacting.Physic import *
from IO_interacting.MQTT_Helper import *
from datetime import datetime, timedelta

# Get current time and adjust for GMT+7
gmt_plus_7 = datetime.utcnow() + timedelta(hours=7)
formatted_time = gmt_plus_7.strftime("%d-%m-%Y %H:%M:%S")

MQTT_SERVER = "mqtt.ohstem.vn"
MQTT_USERNAME = "BK_SmartPole"
MQTT_PASSWORD = " "
MQTT_CLIENT = "NUC"
MQTT_CT01_SENSOR_TOPIC = "BK_SmartPole/feeds/V19"
MQTT_CONTROL_LIGHT_TOPIC = "BK_SmartPole/feeds/V20"


if __name__ == '__main__':
    # Declaring library object
    ai = AI_dectection(fullScreen=None)
    physic = Physic(debug_flag=False)
    mqtt_helper = MQTTClientHelper(broker_host=MQTT_SERVER, username= MQTT_USERNAME, password= MQTT_PASSWORD, client_id= MQTT_CLIENT)
    mqtt_helper.connect()
    mqtt_helper.subscribe(MQTT_CONTROL_LIGHT_TOPIC)
    mqtt_helper.subscribe(MQTT_CT01_SENSOR_TOPIC)

    thread1 = threading.Thread(target=ai.run, name="Thread-AI_Runner")
    thread1.daemon = True
    print('Thread 1 name: ', thread1.name)
    thread1.start()

    thread2 = threading.Thread(target=ai.debounce_thread, name="Thread-Deboucing_AI_Result")
    thread2.daemon = True
    thread2.start()
    print('Thread 2 name: ', thread2.name)

    def getSensorValue():
        for sensor in physic.RS485_sensors_format.keys():
            if sensor == "ambient_light_high" or sensor == "ambient_light_low":
                pass  # Skip these value
            else:
                value = physic.readSensors(sensor)
                print(f"Sensor {sensor}: {value}")

    while True:
        # Read all sensors
        getSensorValue()

        time.sleep(5)
    # while True:
    #     if ai.Person_detected is not None:
    #         if ai.Person_detected:
    #             print("HAVE PERSON!!")
    #         else:
    #             print("NO PERSON!!")
    #     time.sleep(1)


