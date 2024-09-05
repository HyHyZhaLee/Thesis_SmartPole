import os
import sys

# Thêm đường dẫn tới thư mục DS
sys.path.append(os.path.join(os.path.dirname(__file__), 'DS'))

class ObjectTracker(object):
    def __init__(self, trackerObjectName):
        if trackerObjectName == 'sort':
            self.trackerObject = SortTracker()
        elif trackerObjectName == 'deepsort':
            self.trackerObject = DeepSortTracker()
        else:
            print("Invalid Tracker Name")
            self.trackerObject = None

class SortTracker:
    def __init__(self):
        sys.path.append(os.path.join(os.path.dirname(__file__), '../third_party', 'sort-master'))
        from sort import Sort
        self.mot_tracker = Sort()

    def update(self, detections):
        return self.mot_tracker.update(detections)

class DeepSortTracker:
    def __init__(self):
        from DS.deep_sort import DeepSort
        from DS.deep_sort import nn_matching
        from DS.tools.generate_detections import create_box_encoder
        from DS.deep_sort.detection import Detection

        model_filename = os.path.join(os.path.dirname(__file__), 'DS/model_data/mars-small128.pb')
        max_cosine_distance = 0.3
        nn_budget = None
        self.encoder = create_box_encoder(model_filename, batch_size=32)
        self.metric = nn_matching.NearestNeighborDistanceMetric("cosine", max_cosine_distance, nn_budget)
        self.mot_tracker = DeepSort(self.metric, max_iou_distance=0.7, nms_max_overlap=1.0, max_age=70, n_init=3)

    def update(self, bbox_xywh, confidences, classes, frame):
        features = self.encoder(frame, bbox_xywh)
        detections = [Detection(bbox_xywh[i], confidences[i], features[i]) for i in range(len(bbox_xywh))]
        self.mot_tracker.predict()
        self.mot_tracker.update(detections)
        return self.mot_tracker.tracks
