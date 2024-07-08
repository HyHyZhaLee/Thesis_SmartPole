import cv2
import numpy as np
from pycoral.utils.edgetpu import make_interpreter
from pycoral.adapters import common
import time


# Tạo interpreter với Coral USB Accelerator
interpreter = make_interpreter("weights/240_yolov9c.tflite")
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# Khai báo các biến/hàm còn thiếu
SOURCE = np.array([[648, 233], [1443, 218], [1222, 28], [838, 33]])
conf_threshold = 0.65

# Giả sử chiều rộng 16m, chiều cao m
TARGET_WIDTH = 16
TARGET_HEIGHT = 20

TARGET = np.array(
    [
        [0, 0],
        [TARGET_WIDTH - 1, 0],
        [TARGET_WIDTH - 1, TARGET_HEIGHT - 1],
        [0, TARGET_HEIGHT - 1],
    ]
)

class ViewTransformer:
    def __init__(self, source: np.ndarray, target: np.ndarray) -> None:
        source = source.astype(np.float32)
        target = target.astype(np.float32)
        self.m = cv2.getPerspectiveTransform(source, target)

    def transform_points(self, points: np.ndarray) -> np.ndarray:
        if points.size == 0:
            return points

        reshaped_points = points.reshape(-1, 1, 2).astype(np.float32)
        transformed_points = cv2.perspectiveTransform(reshaped_points, self.m)
        return transformed_points.reshape(-1, 2)

def is_point_in_polygon(point, polygon):
    return cv2.pointPolygonTest(polygon, point, False) >= 0

# Load classname từ file classes.names
with open("data_ext/classes.names") as f:
    class_names = f.read().strip().split('\n')

colors = np.random.randint(0, 255, size=(len(class_names), 3))

# Khởi tạo ViewTransformer
view_transformer = ViewTransformer(source=SOURCE, target=TARGET)

# Config value
video_path = "data_ext/highway.mp4"

# Khởi tạo VideoCapture để đọc từ file video
cap = cv2.VideoCapture(video_path)

# Tiến hành đọc từng frame từ video
while True:
    ret, frame = cap.read()
    if not ret:
        continue

    current_time = time.time()
    
    

    # Chuẩn bị đầu vào
    input_data = cv2.resize(frame, (input_details[0]['shape'][2], input_details[0]['shape'][1]))
    input_data = np.expand_dims(input_data, axis=0).astype(np.int8)  # Sử dụng uint8

    # Chạy suy luận
    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()

    # Lấy kết quả đầu ra
    output_data = interpreter.get_tensor(output_details[0]['index'])[0]
    output_scale, output_zero_point = output_details[0]['quantization']
    output_data = (output_data - output_zero_point) * output_scale

    # Kiểm tra đầu ra của mô hình
    #print("Detections: ", output_data)

    # Xử lý kết quả detect
    for detect_object in output_data:
        x1, y1, x2, y2, confidence, class_id = detect_object[:6]
        if confidence < conf_threshold:
            continue

        center_point = ((x1 + x2) // 2, (y1 + y2) // 2)
        if not is_point_in_polygon(center_point, SOURCE):
            continue

        color = colors[int(class_id)]
        B, G, R = map(int, color)
        label = "{}".format(class_names[int(class_id)])
        
        cv2.rectangle(frame, (int(x1), int(y1)), (int(x2), int(y2)), (B, G, R), 2)
        cv2.rectangle(frame, (int(x1) - 1, int(y1) - 20), (int(x1) + len(label) * 12, int(y1)), (B, G, R), -1)
        cv2.putText(frame, label, (int(x1) + 5, int(y1) - 8), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

    if frame is not None:
        cv2.imshow("OT", frame)
    else:
        print("Frame is None, cannot display.")
    if cv2.waitKey(1) == ord("q"):
        break

cap.release()
cv2.destroyAllWindows()

