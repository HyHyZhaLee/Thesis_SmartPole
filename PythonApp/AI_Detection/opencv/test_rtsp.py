import cv2

# RTSP stream URL
rtsp_url = 'rtsp://admin:ACLAB2023@192.168.8.101/ISAPI/Streaming/channels/1'

# Create a VideoCapture object
cap = cv2.VideoCapture(rtsp_url)

# Check if the video stream is opened successfully
if not cap.isOpened():
    print("Error: Unable to open video stream")
else:
    print("Video stream opened successfully")

# Read and display the frames in a loop
while True:
    ret, frame = cap.read()
    if ret:
        cv2.imshow('Frame', frame)
        if cv2.waitKey(1) & 0xFF == ord('q'):  # Press 'q' to quit
            break
    else:
        print("Error: Unable to read frame from the video stream")
        break

# Release the VideoCapture object and close the window
cap.release()
cv2.destroyAllWindows()

