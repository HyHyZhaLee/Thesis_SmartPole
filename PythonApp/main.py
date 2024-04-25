import json
import time

import requests

# Địa chỉ URL mà bạn muốn truy cập
url = 'https://ezdata2.m5stack.com/api/v2/4827E2E30938/dataMacByKey/raw'

# Thực hiện yêu cầu GET
response = requests.get(url)

# Kiểm tra trạng thái phản hồi
while True:
    if response.status_code == 200:
        # Phân tích cú pháp JSON ngoài
        parsed_json = json.loads(response.text)

        # Truy cập vào trường 'value' và giải mã chuỗi JSON bên trong
        inner_json_str = parsed_json['data']['value']
        inner_json = json.loads(inner_json_str.replace('\\', ''))

        # In tất cả dữ liệu từ các cảm biến, làm tròn các giá trị số tới 2 chữ số thập phân
        for sensor, data in inner_json.items():
            for key, value in data.items():
                if isinstance(value, (float, int)):
                    # Làm tròn giá trị số
                    value = round(value, 2)
                print(f"{key}: {value}")
        print()
    else:
        print('Failed response. Code:', response.status_code)
        break
    time.sleep(5)