import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để sử dụng SystemSound
import 'package:provider/provider.dart'; // Để sử dụng Provider
import 'dart:convert'; // Để encode dữ liệu JSON
import '../AppFunction/global_variables.dart';
import '../AppFunction/global_helper_function.dart'; // Để dùng getCurrentTimestamp()
import '../widgets/Physical_Sensor_card.dart';
import '../widgets/dropdown_button_widget.dart';
import '../provider/page_controller_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _currentSliderValue = 0; // Giá trị ban đầu của slider
  bool _isSwitched = false; // Trạng thái cho slider
  String _deviceID = 'NEMA_02'; // ID của thiết bị
  String _statusMessage = 'Disconnected'; // Trạng thái kết nối

  @override
  void initState() {
    super.initState();
    _loadInitialBrightness(); // Load dữ liệu ban đầu từ Firebase
  }

  Future<void> _loadInitialBrightness() async {
    try {
      DatabaseEvent event = await global_databaseReference.child(_deviceID).child("Newest data").once();

      if (event.snapshot.value != null && event.snapshot.value is Map) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _currentSliderValue = (data['brightness'] ?? 0).toDouble();
        });
        print('Initial brightness for $_deviceID: $_currentSliderValue');
      }
    } catch (e) {
      print('Failed to load initial brightness: $e');
    }
  }

  void _publishBrightness(double value, String deviceID) {
    setState(() {
      _currentSliderValue = value;
    });

    var message = jsonEncode({
      "station_id": "SmartPole_0002",
      "station_name": "Smart Pole 0002",
      "timestamp": getCurrentTimestamp(),
      "action": "control light",
      "device_id": deviceID,
      "data": value.round().toString()
    });

    // Gửi dữ liệu qua MQTT
    global_mqttHelper.publish(MQTT_TOPIC, message);

    // Cập nhật dữ liệu lên Firebase
    global_databaseReference.child(deviceID).child("Newest data").set({
      "brightness": value.round(),
      "timestamp": getCurrentTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                // Phần bên trái - Hình ảnh và slider
                Expanded(
                  flex: 45,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE6E5F2), width: 1),
                      borderRadius: BorderRadius.circular(28),
                      color: const Color(0xFFFFFFFF),
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
                              // Slider
                              Positioned(
                                left: 70,
                                top: 335,
                                bottom: 0,
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor: Colors.blue,
                                      inactiveTrackColor: const Color(0xFFF4EEF4),
                                      trackShape: const RoundedRectSliderTrackShape(),
                                      trackHeight: 45.0,
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 25),
                                      overlayColor: Colors.blue.withAlpha(10),
                                      overlayShape: const RoundSliderOverlayShape(
                                          overlayRadius: 60),
                                    ),
                                    child: Slider(
                                      value: _currentSliderValue,
                                      min: 0,
                                      max: 100,
                                      onChanged: (value) {
                                        setState(() {
                                          _currentSliderValue = value;
                                          _isSwitched = _currentSliderValue > 0;
                                        });
                                      },
                                      onChangeEnd: (value) {
                                        _publishBrightness(value, _deviceID);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              // Các nút
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
                                            'Physical devices parameter',
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
                                              child: InfoCard(
                                                iconPath: 'lib/assets/icons/humidity_icon.png', // Replace with your icon path
                                                // iconSize: 25.0, // Adjust the size of the icon
                                                dataName: 'Humidity',
                                                // Height and width of the card = Container height and width
                                                cardHeight: double.infinity,
                                                cardWidth: double.infinity,
                                                value: '80%',
                                                cardColor: Color(0xFF6F5CEA),
                                                onUpdate: () {
                                                  print('Updating humidity...');
                                                },
                                              )
                                            // decoration: BoxDecoration(
                                            //   border: Border.all(color: Color(0xFFE6E5F2), width: 1),
                                            //   borderRadius: BorderRadius.circular(28),
                                            //   color: Color(0xFF6F5CEA),
                                            // ),
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
                                        child: const DropdownButtonWidget(label: "temperature"),
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


  // Nút bấm
  Widget _buildButton(String label, BuildContext context, {int pageIndex = 1}) {
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
