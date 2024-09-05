import argparse
import cv2
import os
import numpy as np
from pycoral.adapters.common import input_size
from pycoral.adapters.detect import get_objects
from pycoral.utils.dataset import read_label_file
from pycoral.utils.edgetpu import make_interpreter, run_inference
from DS.deep_sort.tracker import Tracker
from DS.deep_sort import nn_matching
from DS.tools.generate_detections import create_box_encoder
from DS.deep_sort.detection import Detection

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
    def __init__(self, fullScreen=True):
        self.fullScreen = fullScreen
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

        self.BATCH_SIZE = 1  # Số lượng khung hình trong một batch
        self.SPEED_THRESHOLD = 80.0  # Tốc độ ngưỡng (km/h)
        self.SAVE_DIR = 'captured_vehicles'  # Thư mục để lưu hình ảnh

        # Variables for allowed Coco labels
        self.ALLOWED_LABEL_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]  # Các label của đối tượng được phép

        os.makedirs(self.SAVE_DIR, exist_ok=True)

        # Deep SORT initialization
        model_filename = 'DS/model_data/mars-small128.pb'
        self.encoder = create_box_encoder(model_filename, batch_size=32)
        self.metric = nn_matching.NearestNeighborDistanceMetric("cosine", max_cosine_distance=0.3, nn_budget=None)
        self.tracker = Tracker(self.metric, max_iou_distance=0.7, max_age=70, n_init=3)

    def append_objs_to_img(self, cv2_im, inference_size, objs, labels, previous_positions, previous_times):
        height, width, channels = cv2_im.shape
        scale_x, scale_y = width / inference_size[0], height / inference_size[1]

        bbox_xywh = []
        confidences = []
        classes = []

        for obj in objs:
            if obj.id not in self.ALLOWED_LABEL_IDS:
                continue  # Bỏ qua các object không nằm trong danh sách duyệt

            bbox = obj.bbox.scale(scale_x, scale_y)
            x0, y0 = int(bbox.xmin), int(bbox.ymin)
            x1, y1 = int(bbox.xmax), int(bbox.ymax)
            bbox_xywh.append([(x0 + x1) / 2, (y0 + y1) / 2, x1 - x0, y1 - y0])
            confidences.append(obj.score)
            classes.append(obj.id)

            cv2_im = cv2.rectangle(cv2_im, (x0, y0), (x1, y1), (0, 255, 0), 2)
            label = '{}: {:.2f}'.format(labels.get(obj.id, obj.id), obj.score)
            cv2_im = cv2.putText(cv2_im, label, (x0, y0 + 30), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (255, 0, 0), 2)

        if bbox_xywh:
            features = self.encoder(cv2_im, bbox_xywh)
            detections = [Detection(bbox_xywh[i], confidences[i], features[i]) for i in range(len(bbox_xywh))]
            self.tracker.predict()
            tracks = self.tracker.update(detections)
            for track in tracks:
                if not track.is_confirmed() or track.time_since_update > 1:
                    continue
                track_id = track.track_id
                bbox = track.to_tlbr()
                x0, y0, x1, y1 = map(int, bbox)
                cv2_im = cv2.rectangle(cv2_im, (x0, y0), (x1, y1), (255, 0, 0), 2)
                cv2_im = cv2.putText(cv2_im, f"ID: {track_id}", (x0, y0 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.75, (255, 255, 255), 2)

        return cv2_im

    def run(self):
        default_model_dir = 'AI_Detection/all_models'
        default_model = 'ssdlite_mobiledet_coco_qat_postprocess_edgetpu.tflite'
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
                            default='deepsort', choices=['sort', 'deepsort'])
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

        previous_positions = {}
        previous_times = {}

        frames_batch = []  # Batch of frames

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
                    cv2_im = self.append_objs_to_img(cv2_im, inference_size, objs, labels, previous_positions, previous_times)

                    cv2.imshow('frame', cv2_im)
                    if cv2.waitKey(1) & 0xFF == ord('q'):
                        break

                frames_batch = []  # Reset batch after processing

        cap.release()
        cv2.destroyAllWindows()

if __name__ == '__main__':
    ai = AI_dectection()
    ai.run()
