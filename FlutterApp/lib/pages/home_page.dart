import 'package:flutter/material.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title section
          Container(
            padding: const EdgeInsets.only(left: 70, bottom: 10),
              child: const Text(
              'SMART POLE DASHBOARD',
              style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              )
            )
          ),
          const SizedBox(height: 20),
          // Content section
          Expanded(
            child: Row(
              children: [
                // Left part - Image with overlay labels
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: Image.asset(
                          'lib/assets/SmartPole_pic_with_arrow.png',
                          height: 747,
                        ),
                      ),
                      // Buttons
                      Positioned(
                        top: 00,
                        left: 70,
                        child: _buildButton("NEMA - 01"),
                      ),
                      Positioned(
                        top: 0,
                        right: 160,
                        child: _buildButton("NEMA - ESP32"),
                      ),
                      Positioned(
                        top: 130,
                        left: 70,
                        child: _buildButton("CAMERA"),
                      ),
                      Positioned(
                        top: 130,
                        right: 160,
                        child: _buildButton("AIR SENSOR"),
                      ),
                      Positioned(
                        top: 335,
                        right: 160,
                        child: _buildButton("SCREEN"),
                      ),
                      Positioned(
                        top: 480,
                        right: 160,
                        child: _buildButton("CHARGER"),
                      ),
                    ],
                  ),
                ),
                // Right part - Placeholder for additional UI
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.grey[200],
                    child: const Center(child: Text("Additional Controls")),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Method to create button widget
  Widget _buildButton(String label) {
    return SizedBox(
      width: 201,
      height: 53,
      child: ElevatedButton(
        onPressed: () {
          // Handle button press here
          print('$label button pressed');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9), // Màu nền xám cho nút
          elevation: 0, // Bỏ hiệu ứng đổ bóng
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: PRIMARY_BLACK_COLOR,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

}
