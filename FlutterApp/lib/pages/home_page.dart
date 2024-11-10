import 'package:flutter/material.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';
import 'package:provider/provider.dart';

import '../provider/page_controller_provider.dart';

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
                  flex: 45,
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
                        child: _buildButton("NEMA - 01", context),
                      ),
                      Positioned(
                        top: 0,
                        right: 110,
                        child: _buildButton("NEMA - ESP32", context, pageIndex: 2),
                      ),
                      Positioned(
                        top: 130,
                        left: 70,
                        child: _buildButton("CAMERA", context, pageIndex: 4), // 4 là chỉ số của SecurityCamerasPage
                      ),
                      Positioned(
                        top: 130,
                        right: 110,
                        child: _buildButton("AIR SENSOR", context, pageIndex: 6),
                      ),
                      Positioned(
                        top: 335,
                        right: 110,
                        child: _buildButton("SCREEN", context, pageIndex: 5),
                      ),
                      Positioned(
                        top: 500,
                        right: 110,
                        child: _buildButton("CHARGER", context, pageIndex: 7),
                      ),
                    ],
                  ),
                ),
                // Right part - Placeholder for additional UI
                Expanded(
                  flex: 55,
                  child: Container(
                      child: Column(
                        children:[
                          Expanded(
                            flex: 3,
                            child: Stack(
                              children: [
                                // Màu nền xanh cho phần flex 3
                                Container(
                                  color: Colors.blue,
                                ),
                                // Các thành phần khác trong phần này có thể thêm vào đây
                              ],
                            )
                          ),
                           Expanded(
                            flex: 7,
                            child: Stack(
                              children: [
                                // Màu nền xanh cho phần flex 3
                                Container(
                                  color: Colors.red,
                                ),
                                // Các thành phần khác trong phần này có thể thêm vào đây
                              ],
                            )
                          )
                        ]
                      )
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
  Widget _buildButton(String label, BuildContext context,{int pageIndex = 1}) {
    return SizedBox(
      width: 201,
      height: 53,
      child: ElevatedButton(
        onPressed: () {
          context.read<PageControllerProvider>().setSelectedIndex(pageIndex);
          print('$label button pressed');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD9D9D9),
          elevation: 0,
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
