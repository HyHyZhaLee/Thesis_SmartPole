import cv2
import numpy as np
import tensorflow as tf
from deep_sort_realtime.deepsort_tracker import DeepSort
import time

# Tải mô hình TensorFlow Lite
interpreter = tf.lite.Interpreter(model_path="weights/240_yolov9c.tflite")
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

def detect_objects(frame):
    input_data = cv2.resize(frame, (input_details[0]['shape'][2], input_details[0]['shape'][1]))
    input_data = np.expand_dims(input_data, axis=0).astype(np.float32)

    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()

    output_data = interpreter.get_tensor(output_details[0]['index'])
    return output_data

#Khai báo các biến/hàm còn thiếu

SOURCE = np.array([[648, 233],[1443, 218],[1222, 28],[838, 33]])
conf_threshold = 0.65

#Giả sử chiều rộng 16m , chiều cao m
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

colors = np.random.randint(0,255, size=(len(class_names),3 ))
tracks = []
previous_positions = {}
previous_times = {}
traces = {}

# Khởi tạo DeepSort
tracker = DeepSort(max_age=30)

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
    # Đưa qua model để detect
    detections = detect_objects(frame)

    # Xử lý kết quả detect và DeepSort
    detect = []
    for detect_object in detections[0]:
        confidence, x1, y1, x2, y2, class_id = detect_object[:6]
        if confidence < conf_threshold:
            continue

        center_point = ((x1 + x2) // 2, (y1 + y2) // 2)
        if not is_point_in_polygon(center_point, SOURCE):
            continue

        detect.append([[x1, y1, x2 - x1, y2 - y1], confidence, class_id])

    tracks = tracker.update_tracks(detect, frame=frame)

    for track in tracks:
        if track.is_confirmed():
            track_id = track.track_id
            ltrb = track.to_ltrb()
            class_id = track.get_det_class()
            x1, y1, x2, y2 = map(int, ltrb)

            color = colors[class_id]
            label = "{}-{}".format(class_names[class_id], track_id)
            cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)
            cv2.putText(frame, label, (x1 + 5, y1 - 8), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

            current_position = ((x1 + x2) // 2, (y1 + y2) // 2)
            transformed_position = view_transformer.transform_points(np.array([current_position]))[0]
            if track_id in previous_positions:
                previous_position = previous_positions[track_id]
                previous_time = previous_times[track_id]
                distance = np.linalg.norm(np.array(transformed_position) - np.array(previous_position))
                time_diff = current_time - previous_time
                speed = distance / time_diff if time_diff > 0 else 0
                speed_kmh = speed * 3.6

                cv2.putText(frame, f"Speed: {speed_kmh:.2f} km/h", (x1 + 5, y2 + 15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

            previous_positions[track_id] = transformed_position
            previous_times[track_id] = current_time

    if frame is not None:
        cv2.imshow("OT", frame)
    else:
        print("Frame is None, cannot display.")
    if cv2.waitKey(1) == ord("q"):
        break

cap.release()
cv2.destroyAllWindows()
