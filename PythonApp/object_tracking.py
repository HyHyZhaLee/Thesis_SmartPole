import cv2
import torch
import numpy as np
from deep_sort_realtime.deepsort_tracker import DeepSort
from models.common import DetectMultiBackend, AutoShape
from utils.torch_utils import select_device
import time

#Các điểm Polygon zone
SOURCE = np.array([[648, 233],[1443, 218],[1222, 28],[838, 33]])

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

# Config value
video_path = "data_ext/highway.mp4"

# Vẽ polygon zone lên khung hình
def draw_polygon(frame, points):
    cv2.polylines(frame, [points], isClosed=True, color=(0, 255, 0), thickness=2)

# Kiểm tra xem điểm có nằm trong polygon hay không
def is_point_in_polygon(point, polygon):
    return cv2.pointPolygonTest(polygon, point, False) >= 0

conf_threshold = 0.65
tracking_class = None # None: track all

# Khởi tạo DeepSort
tracker = DeepSort(max_age=30)

# Khởi tạo ViewTransformer
view_transformer = ViewTransformer(source=SOURCE, target=TARGET)

# Khởi tạo YOLOv9
print(torch.cuda.get_device_name(0))
device_type = "cuda" if torch.cuda.is_available() else "cpu"
device = torch.device(device_type)
model  = DetectMultiBackend(weights="weights/yolov9-c-converted.pt", device= device, fuse=True )
model  = AutoShape(model)

# Load classname từ file classes.names
with open("data_ext/classes.names") as f:
    class_names = f.read().strip().split('\n')

colors = np.random.randint(0,255, size=(len(class_names),3 ))
tracks = []
previous_positions = {}
previous_times = {}
traces = {}

#camera
#cap = cv2.VideoCapture(0)
# Khởi tạo VideoCapture để đọc từ file video
cap = cv2.VideoCapture(video_path)
#Cam Trong
#cap = cv2.VideoCapture("rtsp://admin:ACLAB2023@172.28.182.165/ISAPI/Streaming/channels/1")
#Cam ngoài
#cap = cv2.VideoCapture('rtsp://admin:ACLAB2023@172.28.182.108/ISAPI/Streaming/channels/1')

# Tiến hành đọc từng frame từ video
while True:
    # Đọc
    ret, frame = cap.read()
    if not ret:
        continue

    current_time = time.time()
    # Đưa qua model để detect
    results = model(frame)

    detect = []
    for detect_object in results.pred[0]:
        label, confidence, bbox = detect_object[5], detect_object[4], detect_object[:4]
        x1, y1, x2, y2 = map(int, bbox)
        class_id = int(label)

        if class_id > 8 or confidence < conf_threshold:
            continue

        center_point = ((x1 + x2) // 2, (y1 + y2) // 2)
        if not is_point_in_polygon(center_point, SOURCE):
            continue


        detect.append([ [x1, y1, x2-x1, y2 - y1], confidence, class_id ])


    # Cập nhật,gán ID băằng DeepSort
    tracks = tracker.update_tracks(detect, frame = frame)

    # Vẽ polygon zone lên khung hình
    #draw_polygon(frame, SOURCE)

    # Vẽ lên màn hình các khung chữ nhật kèm ID
    for track in tracks:
        if track.is_confirmed():
            track_id = track.track_id

            # Lấy toạ độ, class_id để vẽ lên hình ảnh
            ltrb = track.to_ltrb()
            class_id = track.get_det_class()
            x1, y1, x2, y2 = map(int, ltrb)
            color = colors[class_id]
            B, G, R = map(int,color)

            label = "{}-{}".format(class_names[class_id], track_id)

            cv2.rectangle(frame, (x1, y1), (x2, y2), (B, G, R), 2)
            cv2.rectangle(frame, (x1 - 1, y1 - 20), (x1 + len(label) * 12, y1), (B, G, R), -1)
            cv2.putText(frame, label, (x1 + 5, y1 - 8), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

            # Tính toán tốc độ di chuyển
            current_position = ((x1 + x2) // 2, (y1 + y2) // 2)
            transformed_position = view_transformer.transform_points(np.array([current_position]))[0]
            if track_id in previous_positions:
                previous_position = previous_positions[track_id]
                previous_time = previous_times[track_id]
                distance = np.linalg.norm(np.array(transformed_position) - np.array(previous_position))
                time_diff = current_time - previous_time
                speed = distance / time_diff if time_diff > 0 else 0
                speed_kmh = speed * 3.6  # convert m/s to km/h

                # Hiển thị tốc độ
                cv2.putText(frame, f"Speed: {speed_kmh:.2f} km/h", (x1 + 5, y2 + 15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

            # Cập nhật vị trí và thời gian
            previous_positions[track_id] = transformed_position
            previous_times[track_id] = current_time

            # Lưu vết di chuyển
            if track_id not in traces:
                traces[track_id] = []
            traces[track_id].append(current_position)
            if len(traces[track_id]) > 50:  # Giới hạn độ dài của đường đi
                traces[track_id].pop(0)

            # Vẽ vết di chuyển
            #for i in range(1, len(traces[track_id])):
                #cv2.line(frame, traces[track_id][i - 1], traces[track_id][i], (255, 0, 0), 2)

    # Show hình ảnh lên màn hình
    if frame is not None:
        cv2.imshow("OT", frame)
    else:
        print("Frame is None, cannot display.")
    # Bấm Q thì thoát
    if cv2.waitKey(1) == ord("q"):
        break

cap.release()
cv2.destroyAllWindows()