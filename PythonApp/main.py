import datetime
import time
from IO_interacting.MQTT_Helper import MQTTClientHelper
from IO_interacting.Physic import Physic
import firebase_admin
from firebase_admin import credentials, db

# Firebase Initialization
cred = credentials.Certificate("../../nema-nbiot-controller-firebase.json")
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://nema-nbiot-controller-default-rtdb.asia-southeast1.firebasedatabase.app'
})

# MQTT Server Configuration
MQTT_SERVER = "mqtt.ohstem.vn"
MQTT_USERNAME = "BK_SmartPole"
MQTT_PASSWORD = " "
CLIENT_ID = "BK_SmartPole " + datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S %Z%z")
TOPIC = "BK_SmartPole/feeds/V20"


def sanitize_sensor_name(sensor_name):
    """
    Sanitize sensor name to remove invalid Firebase path characters.
    Replace '.' with '_'.
    """
    return sensor_name.replace('.', '_')


def build_json(station_id, station_name, device_id, sensor_data):
    """
    Build the JSON payload for MQTT publishing.
    """
    timestamp = datetime.datetime.utcnow().isoformat() + "Z"
    return {
        "station_id": station_id,
        "station_name": station_name,
        "action": "update data",
        "device_id": device_id,
        "timestamp": timestamp,
        "data": sensor_data
    }


def upload_to_firebase(device_id, sensor_name, value):
    """
    Upload data to Firebase in the format: ID/sensor_name/date-month-year/time
    """
    try:
        now = datetime.datetime.now()
        date = now.strftime("%Y-%m-%d")  # Định dạng YYYY-MM-DD để sắp xếp đúng
        time = now.strftime("%H:%M:%S")

        # Sanitize the sensor name
        sanitized_sensor_name = sanitize_sensor_name(sensor_name)

        # Construct the Firebase path
        path = f"NEMA_0002/{device_id}/{sanitized_sensor_name}/{date}/{time}"

        # Upload data
        ref = db.reference(path)
        ref.set(value)
        print(f"[FIREBASE] Uploaded: {path} -> {value}")
    except Exception as e:
        print(f"[ERROR] Failed to upload to Firebase: {e}")


def main():
    # Initialize Physic and MQTT Helper
    physic = Physic(False)  # Initialize the class with debug mode enabled
    mqtt_helper = MQTTClientHelper(MQTT_SERVER, MQTT_USERNAME, MQTT_PASSWORD, CLIENT_ID)
    mqtt_helper.connect()
    mqtt_helper.subscribe(TOPIC)

    # Station and Device Information
    station_id = "SmartPole_0002"
    station_name = "Smart Pole 0002"
    device_id = "AIR_0002"

    # Read and Publish Sensor Data
    while True:
        try:
            sensor_data = {}
            for sensor in physic.RS485_sensors_format.keys():
                if sensor in ["ambient_light_high", "ambient_light_low"]:
                    continue  # Skip these values

                value = physic.readSensors(sensor)
                sensor_data[sensor] = value
                print(f"Sensor {sensor}: {value}")

                # Upload each sensor's data to Firebase
                upload_to_firebase(device_id, sensor, value)

            # Build JSON Payload
            json_payload = build_json(station_id, station_name, device_id, sensor_data)
            print("[MQTT] Publishing JSON Payload:", json_payload)

            # Publish to MQTT Server
            mqtt_helper.publish(TOPIC, json_payload)
        except Exception as e:
            print(f"[ERROR] Main Loop Exception: {e}")

        time.sleep(600)  # Pause before the next read sequence


if __name__ == '__main__':
    main()
