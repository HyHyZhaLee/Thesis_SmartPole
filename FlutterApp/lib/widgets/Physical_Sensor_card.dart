import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String iconPath; // Đường dẫn icon
  // final double iconSize; // Kích thước icon
  final String dataName; // Tên dữ liệu (VD: "Humidity")
  final String value; // Giá trị hiển thị (VD: "80%")
  final VoidCallback? onUpdate; // Hàm cập nhật khi nhấn vào
  final Color cardColor; // Màu thẻ
  final double cardWidth; // Chiều rộng thẻ
  final double cardHeight; // Chiều cao thẻ

  const InfoCard({
    Key? key,
    required this.iconPath,
    // required this.iconSize,
    required this.dataName,
    required this.value,
    this.onUpdate,
    this.cardColor = Colors.purple, // Mặc định là màu tím
    this.cardWidth = 150.0, // Mặc định chiều rộng
    this.cardHeight = 100.0, // Mặc định chiều cao
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpdate, // Gọi hàm khi nhấn vào thẻ (nếu có)
      child: Container(
        width: cardWidth, // Kích thước chiều rộng
        height: cardHeight, // Kích thước chiều cao
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cardColor, // Màu nền của thẻ
          border: Border.all(color: Color(0xFFE6E5F2), width: 1),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  iconPath,
                  // height: iconSize,
                  // width: iconSize,
                  fit: BoxFit.contain,
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8.0), // Khoảng cách giữa các hàng
            Text(
              dataName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
