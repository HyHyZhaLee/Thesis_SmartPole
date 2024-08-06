import smbus

bus = smbus.SMBus(16)
I2C_ADDRESS = 0x20

try:
    # Read a byte from register 0x00 (or another register)
    data = bus.read_byte_data(I2C_ADDRESS, 0x00)
    print(f"Data read: {data}")
except Exception as e:
    print(f"Error: {e}")
