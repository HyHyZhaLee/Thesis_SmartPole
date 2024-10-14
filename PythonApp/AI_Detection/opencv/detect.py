import argparse
import cv2
import os
import numpy as np
from pycoral.adapters.common import input_size
from pycoral.adapters.detect import get_objects
from pycoral.utils.dataset import read_label_file
from pycoral.utils.edgetpu import make_interpreter, run_inference
from tracker import ObjectTracker
import time
import threading

lock = threading.Lock()

class ViewTransformer:
    def __init__(self, source: np.ndarray, target: np.ndarray) -> None:
        if source.shape[0] != 4 or target.shape[0] != 4:
            self.m = None  # Không thực hiện biến đổi nếu không đủ 4 điểm
        else:
            source = source.astype(np.float32)
            target = target.astype(np.float32)
            self.m = cv2.getPerspectiveTransform(source, target)

    def transform_points(self, points: np.ndarray) -> np.ndarray:
        if points.size == 0 or self.m is None:
            return points  # Trả về điểm gốc nếu không có biến đổi phối cảnh

        reshaped_points = points.reshape(-1, 1, 2).astype(np.float32)
        transformed_points = cv2.perspectiveTransform(reshaped_points, self.m)
        return transformed_points.reshape(-1, 2)

class AI_dectection:
    def __init__(self):
        # Config value
        self.SOURCE = np.empty((0, 2), dtype=np.float32)
        self.TARGET_WIDTH = 16
        self.TARGET_HEIGHT = 20
        self.TARGET = np.array(
            [
                [0, 0],
                [self.TARGET_WIDTH - 1, 0],
                [self.TARGET_WIDTH - 1, self.TARGET_HEIGHT - 1],
                [0, self.TARGET_HEIGHT - 1],
            ]
        )

        self.BATCH_SIZE = 4  # Số lượng khung hình trong một batch
        self.SPEED_THRESHOLD = 80.0  # Tốc độ ngưỡng (km/h)
        self.SAVE_DIR = 'captured_vehicles'  # Thư mục để lưu hình ảnh

        # Variables for allowed Coco labels
        self.ALLOWED_LABEL_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
                                  10]  # person, bicycle, car, motorcycle, airplane, bus, train, truck, boat, traffic light, fire hydrant

        # Variables for debouncing signal
        self.Person_detected = None
        self.Detect_1 = False
        self.Detect_2 = False
        self.Detect_3 = False
        self.label_name = None

        os.makedirs(self.SAVE_DIR, exist_ok=True)

    def append_objs_to_img(self, cv2_im, inference_size, objs, labels, tracker, view_transformer, previous_positions, previous_times):
        height, width, channels = cv2_im.shape
        scale_x, scale_y = width / inference_size[0], height / inference_size[1]

        detect = []




        for obj in objs:
            if obj.id not in self.ALLOWED_LABEL_IDS:
                continue  # Bỏ qua các object không nằm trong danh sách duyệt

            if obj.score < 0.5:
                continue  # Bỏ qua nếu xác suất không đủ cao

            bbox = obj.bbox.scale(scale_x, scale_y)
            x0, y0 = int(bbox.xmin), int(bbox.ymin)
            x1, y1 = int(bbox.xmax), int(bbox.ymax)
            with lock:
                self.label_name = '{}'.format(labels.get(obj.id, obj.id))
                if self.label_name == 'person':
                    self.Detect_1 = True

                cv2_im = cv2.rectangle(cv2_im, (x0, y0), (x1, y1), (0, 255, 0), 2)
                cv2_im = cv2.putText(cv2_im, self.label_name, (x0, y0 + 30), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 0, 0), 2)
                detect.append([x0, y0, x1, y1, obj.score])

        if len(detect) > 0:
            tracks = tracker.update(np.array(detect))
        else:
            tracks = []  # Không có đối tượng nào được phát hiện

        # Xử lý các phát hiện (vẫn giữ nguyên từ code trước)
        for track in tracks:
            track_id = int(track[4])
            x0, y0, x1, y1 = map(int, track[:4])
            color = (0, 255, 0)
            label = "ID: {}".format(track_id)
            cv2.rectangle(cv2_im, (x0, y0), (x1, y1), color, 2)
            cv2.putText(cv2_im, label, (x0, y0 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)

            # Không thực hiện biến đổi nếu không có SOURCE
            if view_transformer.m is not None:
                current_position = ((x0 + x1) // 2, (y0 + y1) // 2)
                transformed_position = view_transformer.transform_points(np.array([current_position]))[0]

                if track_id in previous_positions:
                    previous_position = previous_positions[track_id]
                    previous_time = previous_times[track_id]
                    distance = np.linalg.norm(np.array(transformed_position) - np.array(previous_position))
                    time_diff = time.time() - previous_time
                    speed = distance / time_diff if time_diff > 0 else 0
                    speed_kmh = speed * 3.6  # convert m/s to km/h
                    cv2.putText(cv2_im, f"Speed: {speed_kmh:.2f} km/h", (x0 + 5, y1 + 15), cv2.FONT_HERSHEY_SIMPLEX, 0.5,
                                (255, 255, 255), 2)

                previous_positions[track_id] = transformed_position
                previous_times[track_id] = time.time()

        return cv2_im

    def debounce_thread(self):
        while True:
            time.sleep(0.3)  # Chờ 0.3 giây

            with lock:
            #print(self.label_name)
                if self.label_name == 'person':
                    # Debouncing logic
                    if self.Detect_1 and self.Detect_2:  # Nếu Detect_1 và Detect_2 đều là True từ trước
                        self.Detect_3 = True  # Đặt Detect_3 thành True
                    elif self.Detect_1:  # Nếu chỉ có Detect_1 là True
                        self.Detect_2 = True  # Đặt Detect_2 thành True
                        self.Detect_3 = False  # Reset Detect_3
                    else:
                        self.Detect_1 = True  # Đặt Detect_1 thành True
                        self.Detect_2 = self.Detect_3 = False  # Reset Detect_2 và Detect_3

                    if self.Detect_1 and self.Detect_2 and self.Detect_3:
                        self.Person_detected = True
                else:
                    self.Detect_1 = self.Detect_2 = self.Detect_3 = False  # Đặt lại nếu không phát hiện 'person'
                    self.Person_detected = False
                self.label_name = None


    def run(self):
        default_model_dir = '../all_models'
        default_model = 'mobilenet_ssd_v2_coco_quant_postprocess_edgetpu.tflite'
        default_labels = 'coco_labels.txt'
        parser = argparse.ArgumentParser()
        parser.add_argument('--model', help='.tflite model path',
                            default=os.path.join(default_model_dir, default_model))
        parser.add_argument('--labels', help='label file path',
                            default=os.path.join(default_model_dir, default_labels))
        parser.add_argument('--top_k', type=int, default=3,
                            help='number of categories with highest score to display')
        parser.add_argument('--camera_idx', type=int, help='Index of which video source to use.', default=0)
        parser.add_argument('--threshold', type=float, default=0.1,
                            help='classifier score threshold')
        parser.add_argument('--video', help='Path to the video file', default=None)
        parser.add_argument('--tracker', help='Name of the Object Tracker To be used.',
                            default='sort', choices=['sort'])
        args = parser.parse_args()

        print('Loading {} with {} labels.'.format(args.model, args.labels))
        interpreter = make_interpreter(args.model)
        interpreter.allocate_tensors()
        labels = read_label_file(args.labels)
        inference_size = input_size(interpreter)

        if args.video:
            cap = cv2.VideoCapture(args.video)
        else:
            # RTSP stream URL
            rtsp_url = 'rtsp://admin:ACLAB2023@192.168.8.101/ISAPI/Streaming/channels/1'
            cap = cv2.VideoCapture(rtsp_url)

        if not cap.isOpened():
            print("Error: Unable to open video stream")
            return

        tracker = ObjectTracker(args.tracker).trackerObject
        view_transformer = ViewTransformer(self.SOURCE, self.TARGET)
        previous_positions = {}
        previous_times = {}

        frames_batch = []  # Batch of frames

        # # Tạo cửa sổ và thiết lập chế độ toàn màn hình
        cv2.namedWindow("frame", cv2.WND_PROP_FULLSCREEN)
        cv2.setWindowProperty("frame", cv2.WND_PROP_FULLSCREEN, cv2.WINDOW_FULLSCREEN)

        while cap.isOpened():
            ret, frame = cap.read()
            if not ret:
                print("Error: Unable to read frame from the video stream")
                break

            frames_batch.append(frame)

            if len(frames_batch) == self.BATCH_SIZE:
                for cv2_im in frames_batch:
                    cv2_im_rgb = cv2.cvtColor(cv2_im, cv2.COLOR_BGR2RGB)
                    cv2_im_rgb = cv2.resize(cv2_im_rgb, inference_size)
                    run_inference(interpreter, cv2_im_rgb.tobytes())
                    objs = get_objects(interpreter, args.threshold)[:args.top_k]
                    cv2_im = self.append_objs_to_img(cv2_im, inference_size, objs, labels, tracker, view_transformer,
                                                     previous_positions, previous_times)

                    cv2.imshow('frame', cv2_im)
                    if cv2.waitKey(1) & 0xFF == ord('q'):
                        break

                frames_batch = []  # Reset batch after processing

        cap.release()
        cv2.destroyAllWindows()

if __name__ == '__main__':
    ai = AI_dectection()
    ai.run()
    # thread2 = threading.Thread(target=ai.run, name="Thread-2")
    # thread2.daemon = True
    # print('Thread 2 name: ', thread2.name)
    # thread2.start()
    #
    # thread1 = threading.Thread(target=ai.debounce_thread, name="Thread-1")
    # thread1.daemon = True
    # thread1.start()
    # print('Thread 1 name: ', thread1.name)
    #
    # while True:
    #     if ai.Person_detected is not None:
    #         if ai.Person_detected:
    #             print("HAVE PERSON!!")
    #         else:
    #             print("NO PERSON!!")
    #     time.sleep(1)


