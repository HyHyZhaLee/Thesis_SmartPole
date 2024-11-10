import 'package:flutter/material.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';
import 'package:provider/provider.dart';
import '../widgets/dropdown_button_widget.dart';
import '../provider/page_controller_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right:10),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Left part - Image with overlay labels, wrapped with a white border
                Expanded(
                  flex: 45,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE6E5F2), width: 1), // Khung viền màu trắng
                      borderRadius: BorderRadius.circular(28),
                      color: Color(0xFFFFFFFF),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.only(left: 40, bottom: 10),
                          child: const Text(
                            'SMART POLE DASHBOARD',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: Stack(
                            alignment: Alignment.centerLeft,
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
                                top: 0,
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
                                child: _buildButton("CAMERA", context, pageIndex: 4),
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
                      ],
                    ),
                  ),
                ),
                // Khoảng cách 20px giữa phần trái và phải
                const SizedBox(width: 20),
                // Right part - Placeholder for additional UI
                Expanded(
                  flex: 55,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFE6E5F2), width: 1),
                      borderRadius: BorderRadius.circular(28),
                      color: Color(0xFFF5F5F5),
                    ),
                    padding: const EdgeInsets.only(left: 44, right: 31),
                    child: Column(
                      children: [
                        Expanded(
                            flex: 6,

                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Physical information',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600, // Đặt fontWeight bên trong TextStyle
                                      ),
                                    ),
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child:
                                      IconButton(
                                          onPressed: (){
                                            print('Refresh button pressed');
                                            //TODO: Refresh button pressed
                                          },
                                          icon: Image.asset(
                                            'lib/assets/icons/refresh_icon.png',
                                            height: 30)),
                                    )
                                ),
                                const SizedBox(width: 20),
                              ],
                            )
                        ),
                        Expanded(
                            flex: 18,
                            child: Container(
                              child: Row(
                                children: [

                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFE6E5F2), width: 1),
                                        borderRadius: BorderRadius.circular(28),
                                        color: Color(0xFF3ACBE9),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFE6E5F2), width: 1),
                                        borderRadius: BorderRadius.circular(28),
                                        color: Color(0xFFF2946D),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFE6E5F2), width: 1),
                                        borderRadius: BorderRadius.circular(28),
                                        color: Color(0xFF6F5CEA),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            )
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                            flex: 33,
                            child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFFE6E5F2), width: 1),
                                  borderRadius: BorderRadius.circular(28),
                                  color: Color(0xFFFFFFFF),
                                ),
                              )
                        ),Expanded(
                            flex: 6,

                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: const Text(
                                        'History graph',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600, // Đặt fontWeight bên trong TextStyle
                                        ),
                                      ),
                                    )
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: DropdownButtonWidget(label: "temperature"),
                                    ),
                                ),
                                const SizedBox(width: 20),
                              ],
                            )
                        ),
                        Expanded(
                            flex: 30,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFE6E5F2), width: 1),
                                borderRadius: BorderRadius.circular(28),
                                color: Color(0xFFFFFFFF),
                              ),
                            )
                        ),
                        const SizedBox(height: 20),
                      ],
                    )
                    )
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
