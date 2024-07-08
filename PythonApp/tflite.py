import cv2
import numpy as np
from tflite_runtime.interpreter import Interpreter
from tflite_runtime.interpreter import load_delegate

# Tạo interpreter từ file mô hình và sử dụng Edge TPU delegate
interpreter = Interpreter(
    model_path="weights/240_yolov9c.tflite",
    experimental_delegates=[load_delegate('libedgetpu.so.1')]
)
interpreter.allocate_tensors()

input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

# In thông tin chi tiết về tensor đầu vào
print(f"Input details: {input_details}")

# Lấy kiểu dữ liệu của tensor đầu vào
input_dtype = input_details[0]['dtype']
print(f"Input data type: {input_dtype}")

