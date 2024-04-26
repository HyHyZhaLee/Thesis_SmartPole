import serial

# Khởi tạo đối tượng Serial với cổng COMx (thay x bằng số cổng UART bạn đang sử dụng) và tốc độ baud rate
ser = serial.Serial('COM4',115200)  # Thay 'COM1' bằng cổng UART thực tế và 9600 bằng baud rate tương ứng

try:
    while True:
        # Đọc dữ liệu từ UART
        data = ser.readline().decode('utf-8').strip()  # Đọc một dòng dữ liệu và chuyển sang kiểu string

        # Xử lý dữ liệu ở đây
        print(data)

except KeyboardInterrupt:
    # Đóng cổng UART khi người dùng nhấn Ctrl+C
    ser.close()