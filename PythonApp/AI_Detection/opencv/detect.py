from collections import defaultdict, deque
import argparse
import collections
import os
import time
import cv2
import numpy as np
from pycoral.adapters.common import input_size
from pycoral.adapters.detect import get_objects
from pycoral.utils.dataset import read_label_file
from pycoral.utils.edgetpu import make_interpreter, run_inference
from sort.sort import Sort
from tracker import ObjectTracker

# Named tuple for bounding boxes
BBox = collections.namedtuple('BBox', ['xmin', 'ymin', 'xmax', 'ymax'])
ALLOWED_LABEL_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]  # Adjust as needed

# Polygon and transformation configurations
SOURCE = np.array([[648, 233], [1443, 218], [1222, 28], [838, 33]])
TARGET_WIDTH = 16  # Width of real-world area in meters
TARGET_HEIGHT = 20  # Height of real-world area in meters
TARGET = np.array(
    [
        [0, 0],
        [TARGET_WIDTH - 1, 0],
        [TARGET_WIDTH - 1, TARGET_HEIGHT - 1],
        [0, TARGET_HEIGHT - 1],
    ]
)
SPEED_THRESHOLD = 80.0  # Speed threshold in km/h

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

def normalize_bbox(bbox, width, height):
    """Normalize bounding box coordinates to [0, 1]."""
    xmin, ymin, xmax, ymax = bbox
    return xmin / width, ymin / height, xmax / width, ymax / height

def denormalize_bbox(bbox, width, height):
    """Convert normalized coordinates to absolute pixel values."""
    xmin, ymin, xmax, ymax = bbox
    return int(xmin * width), int(ymin * height), int(xmax * width), int(ymax * height)

def main():
    # Default paths
    default_model_dir = '../all_models'
    default_model = 'mobilenet_ssd_v2_coco_quant_postprocess_edgetpu.tflite'
    default_labels = 'coco_labels.txt'

    # Parse arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--model', default=os.path.join(default_model_dir, default_model))
    parser.add_argument('--labels', default=os.path.join(default_model_dir, default_labels))
    parser.add_argument('--top_k', type=int, default=3, help='Number of top results to consider')
    parser.add_argument('--threshold', type=float, default=0.5, help='Detection confidence threshold')
    parser.add_argument('--video', default=0, help='Path to video file or camera index')
    parser.add_argument('--tracker', default='sort', help='Name of the tracker to use', choices=['sort'])
    args = parser.parse_args()

    # Load the detection model and labels
    print(f'Loading model {args.model} with labels {args.labels}')
    interpreter = make_interpreter(args.model)
    interpreter.allocate_tensors()
    labels = read_label_file(args.labels)
    inference_size = input_size(interpreter)

    # Initialize tracker, smoothing buffer, and view transformer
    mot_tracker = Sort(max_age=30, min_hits=3)
    smoothing_buffers = defaultdict(lambda: deque(maxlen=5))  # Track ID -> Last N bounding boxes
    view_transformer = ViewTransformer(SOURCE, TARGET)

    # Initialize video capture
    if args.video and args.video != '0':
        cap = cv2.VideoCapture(args.video)
    else:
        rtsp_url = 'rtsp://admin:ACLAB2023@192.168.8.101/ISAPI/Streaming/channels/1'
        cap = cv2.VideoCapture(rtsp_url)

    if not cap.isOpened():
        print("Error: Unable to open video source.")
        return

    frame_count = 0
    start_time = time.time()
    previous_positions = {}
    previous_times = {}

    # Get FPS of the video
    fps = cap.get(cv2.CAP_PROP_FPS)
    frame_interval = 1 / fps if fps > 0 else 0

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            print("End of video stream or unable to read the frame.")
            cap.set(cv2.CAP_PROP_POS_FRAMES, 0)  # Restart the video
            continue

        h, w, _ = frame.shape
        rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        resized_frame = cv2.resize(rgb_frame, inference_size)

        # Run detection
        run_inference(interpreter, resized_frame.tobytes())
        objs = get_objects(interpreter, score_threshold=args.threshold)[:args.top_k]

        # Prepare detections for the tracker
        detections = []
        for obj in objs:
            if obj.id not in ALLOWED_LABEL_IDS:
                continue

            bbox = obj.bbox.scale(w / inference_size[0], h / inference_size[1])
            x0, y0, x1, y1 = int(bbox.xmin), int(bbox.ymin), int(bbox.xmax), int(bbox.ymax)

            detections.append([x0 / w, y0 / h, x1 / w, y1 / h, obj.score])

        detections = np.array(detections)
        trdata = mot_tracker.update(detections) if detections.size > 0 else []

        # Process and smooth tracking results
        for td in trdata:
            x0, y0, x1, y1, track_id = td

            # Add current bounding box to smoothing buffer
            smoothing_buffers[track_id].append([x0, y0, x1, y1])

            # Compute smoothed bounding box
            smoothed_bbox = np.mean(smoothing_buffers[track_id], axis=0)
            x0, y0, x1, y1 = smoothed_bbox
            abs_bbox = (
                int(x0 * w),
                int(y0 * h),
                int(x1 * w),
                int(y1 * h),
            )

            # Draw smoothed tracking results
            cv2.rectangle(frame, abs_bbox[:2], abs_bbox[2:], (0, 255, 0), 2)
            cv2.putText(frame, f"ID: {int(track_id)}", (abs_bbox[0], abs_bbox[1] - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

            # Speed Calculation
            current_position = ((abs_bbox[0] + abs_bbox[2]) / 2, (abs_bbox[1] + abs_bbox[3]) / 2)
            transformed_position = view_transformer.transform_points(np.array([current_position]))[0]
            current_frame_id = int(cap.get(cv2.CAP_PROP_POS_FRAMES))

            if track_id in previous_positions:
                previous_position = previous_positions[track_id]
                previous_time = previous_times[track_id]

                distance = np.linalg.norm(np.array(transformed_position) - np.array(previous_position))
                time_diff = frame_interval * (current_frame_id - previous_times.get(track_id, current_frame_id))

                speed = distance / time_diff if time_diff > 0 else 0
                speed_kmh = speed * 3.6  # Convert m/s to km/h

                # Display Speed
                cv2.putText(frame, f"Speed: {speed_kmh:.2f} km/h", (abs_bbox[0], abs_bbox[3] + 15),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)

            # Update tracking data
            previous_positions[track_id] = transformed_position
            previous_times[track_id] = current_frame_id

        # Calculate and display FPS
        frame_count += 1
        elapsed = time.time() - start_time
        if elapsed > 1:
            fps_display = frame_count / elapsed
            cv2.putText(frame, f"FPS: {fps_display:.2f}", (10, 30), cv2.FONT_HERSHEY_SIMPLEX, 1.0, (0, 255, 0), 2)

        # Display frame
        cv2.imshow('frame', frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    cap.release()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()
