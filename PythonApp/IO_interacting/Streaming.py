import yt_dlp
import vlc
import time
from PIL import Image, ImageDraw, ImageFont

# Đường dẫn đến video YouTube
url = 'https://youtube.com/live/uUaNEJBOM_8?feature=share'

# Tùy chọn tải
ydl_opts = {
    'format': 'best',  # Chọn định dạng tốt nhất
}

# Sử dụng yt-dlp để lấy thông tin stream
with yt_dlp.YoutubeDL(ydl_opts) as ydl:
    info_dict = ydl.extract_info(url, download=False)
    video_url = info_dict['url']
    print("Stream URL:", video_url)

# Khởi tạo VLC player
player = vlc.MediaPlayer(video_url)

# Phát video
player.play()

# Chờ một chút để đảm bảo video bắt đầu phát
time.sleep(5)  # Chờ 5 giây, điều chỉnh nếu cần thiết

# Chuyển sang chế độ toàn màn hình
player.set_fullscreen(True)

# Create an overlay image with text "hello world"
width, height = 1280, 720  # Adjust to your screen size
image = Image.new('RGBA', (width, height), (255, 255, 255, 0))
draw = ImageDraw.Draw(image)
font = ImageFont.truetype("arial.ttf", 50)  # Make sure the font file is available
text = "hello world"
textwidth, textheight = draw.textsize(text, font)
x = (width - textwidth) // 2
y = (height - textheight) // 2
draw.text((x, y), text, font=font, fill=(255, 255, 255, 255))
image.save("overlay.png")

# Add the overlay to the VLC player
overlay_id = player.video_get_spu() + 1  # Get a new overlay ID
player.video_set_spu(overlay_id)  # Set the new overlay
player.video_set_spu_file("overlay.png")  # Set the overlay image file

# Giữ chương trình chạy cho đến khi người dùng đóng trình phát
try:
    while True:
        time.sleep(1)
except KeyboardInterrupt:
    # Thoát chương trình khi nhận tín hiệu từ bàn phím (Ctrl+C)
    print("Exiting...")
finally:
    # Dừng và thoát trình phát VLC
    player.stop()
    player.release()

