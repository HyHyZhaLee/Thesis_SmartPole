import serial

# Khởi tạo đối tượng Serial với cổng COMx (thay x bằng số cổng UART bạn đang sử dụng) và tốc độ baud rate
ser = serial.Serial('COM9',115200)  # Thay 'COM1' bằng cổng UART thực tế và 9600 bằng baud rate tương ứng

try:
    while True:
        # Đọc dữ liệu từ UART
        data = ser.readline().decode('iso-8859-1').strip()  # Replace 'iso-8859-1' with the correct encoding if known

        # Xử lý dữ liệu ở đây
        print(data)

except KeyboardInterrupt:
    # Đóng cổng UART khi người dùng nhấn Ctrl+C
    ser.close()