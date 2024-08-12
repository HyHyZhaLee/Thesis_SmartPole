import sys
import time
import serial.tools.list_ports
import serial

def crc16_modbus(data):
    """
    Calculate the CRC16 for a data array for Modbus RTU.
    :param data: The data array (excluding the CRC).
    :return: CRC16 as a tuple of two bytes.
    """
    crc = 0xFFFF
    for pos in data:
        crc ^= pos
        for i in range(8):
            if (crc & 1) != 0:
                crc >>= 1
                crc ^= 0xA001
            else:
                crc >>= 1
    return [crc & 0xFF, (crc >> 8) & 0xFF]

class Physic:
    def __init__(self, debug_flag=False):
        """Initializes the Physics class with a debug flag and the actuators and sensors formats.
        It attempts to open a serial connection to a specified port."""
        self.debug_flag = debug_flag  # Debug flag to control debug output

        # Each key-value pair represents the command to turn a relay on or off
        # The array format is:
        # [ID, function code, starting address high byte, starting address low byte, data high byte, data low byte, CRC low byte, CRC high byte]
        self.RS485_sensors_format = {
            "temperature": [0x14, 0x03, 0x01, 0xF5, 0x00, 0x01, 0x97, 0x01],
            "humidity": [0x14, 0x03, 0x01, 0xF4, 0x00, 0x01, 0xC6, 0xC1],
            "noise": [0x14, 0x03, 0x01, 0xF6, 0x00, 0x01, 0x67, 0x01],
            "PM2.5": [0x14, 0x03, 0x01, 0xF7, 0x00, 0x01, 0x36, 0xC1],
            "PM10": [0x14, 0x03, 0x01, 0xF8, 0x00, 0x01, 0x06, 0xC2],
            "air_pressure": [0x14, 0x03, 0x01, 0xF9, 0x00, 0x01, 0x57, 0x02],
            "ambient_light": [],
            "ambient_light_high": [0x14, 0x03, 0x01, 0xFA, 0x00, 0x01, 0xA7, 0x02],
            "ambient_light_low": [0x14, 0x03, 0x01, 0xFB, 0x00, 0x01, 0xF6, 0xC2],
        }

        self.portname = self.getPort()  # Retrieve the serial port to use

        # Attempt to open the serial port with specified baudrate
        try:
            self.ser = serial.Serial(port=self.portname, baudrate=9600)
            print("Open successfully port: ", self.portname)
        except:
            print("Exception: Can not open the port")
            sys.exit()  # Exit the program if the serial port cannot be opened

    def getPort(self):
        """Searches for and returns the first available USB serial port."""
        ports = serial.tools.list_ports.comports()
        commPort = "None"
        for i in range(len(ports)):
            port = ports[i]
            strPort = str(port)
            print(strPort)
            if "USB Serial" in strPort:  # Checks if the port description contains 'USB'
                splitPort = strPort.split(" ")
                commPort = splitPort[0]  # Assumes the first part is the port name
        return commPort


    def serial_read_data(self):
        """Reads incoming data from the serial port and decodes it."""
        bytesToRead = self.ser.inWaiting()  # Checks how many bytes are waiting to be read
        if bytesToRead > 0:
            out = self.ser.read(bytesToRead)
            data_array = [b for b in out]  # Converts the bytes to a list for easier processing
            if self.debug_flag:
                print("Return data:", data_array)
            if len(data_array) == 7:
                array_size = len(data_array)
                value = data_array[array_size - 4] * 256 + data_array[array_size - 3]
                return data_array, value
            else:
                return data_array, None
        return None, None

    def readSensors(self, sensorName):
        """Sends a command to read data from a specified sensor."""
        if sensorName == "ambient_light":
            # Read ambient light high byte
            command_data_high = self.RS485_sensors_format.get("ambient_light_high")
            if self.debug_flag:
                print("Sending data for high byte: ", command_data_high)
            self.ser.write(command_data_high)
            time.sleep(1)
            return_data_high, high_byte = self.serial_read_data()
            if self.debug_flag:
                print("Received data for high byte: ", return_data_high)

            # Read ambient light low byte
            command_data_low = self.RS485_sensors_format.get("ambient_light_low")
            if self.debug_flag:
                print("Sending data for low byte: ", command_data_low)
            self.ser.write(command_data_low)
            time.sleep(1)
            return_data_low, low_byte = self.serial_read_data()
            if self.debug_flag:
                print("Received data for low byte: ", return_data_low)

            if high_byte is not None and low_byte is not None:
                ambient_light_value = high_byte * 256 + low_byte
                return ambient_light_value

        else:
            command_data = self.RS485_sensors_format.get(sensorName)
            if self.debug_flag:
                print("Sending data: ", command_data)
            self.ser.write(command_data)  # Sends the command data to the sensor
            time.sleep(1)  # Wait a bit for the sensor to respond
            return_data, result = self.serial_read_data()  # Reads the response from the sensor
            if self.debug_flag:
                print("Received data ", return_data)
            if sensorName == "PM2.5" or sensorName == "PM10":
                return result  # PM2.5 and PM10 are already in the correct scale
            else:
                return result / 10.0  # Divide by 10 for other sensors

if __name__ == '__main__':
    physic = Physic(False)  # Initialize the class with debug mode enabled

    # Test sequence for actuators and sensors
    while True:
        # Read all sensors
        for sensor in physic.RS485_sensors_format.keys():
            if sensor == "ambient_light_high" or sensor == "ambient_light_low":
                pass  # Skip these value
            else:
                value = physic.readSensors(sensor)
                print(f"Sensor {sensor}: {value}")
        time.sleep(5)  # Pause before the next read sequence
