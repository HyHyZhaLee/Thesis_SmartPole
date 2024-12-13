import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Để sử dụng SystemSound
import 'package:provider/provider.dart'; // Để sử dụng Provider
import 'dart:convert'; // Để encode dữ liệu JSON
import '../AppFunction/global_variables.dart';
import '../AppFunction/global_helper_function.dart'; // Để dùng getCurrentTimestamp()
import '../widgets/dropdown_button_widget.dart';
import '../provider/page_controller_provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter_app/widgets/line_chart_temp_homepage.dart';
import 'package:flutter_app/widgets/temperature_line_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _currentSliderValue = 0; // Giá trị ban đầu của slider
  bool _isSwitched = false; // Trạng thái cho switch bên phải
  String _deviceID = "NEMA_0002"; // ID của thiết bị
  String _stationID = "AIR_0002";

  String _statusMessage = 'Disconnected'; // Trạng thái kết nối
  String _humidityValue = '80'; // Thông tin độ ẩm
  String _temperatureValue = '20'; // Thông tin nhiệt độ
  String _pm10 = '100'; // Thông tin hạt bụi mịn bán kính 10
  String _pm2_5 = '100';
  String _airPressure = "0";
  String _ambientLight = "0";
  String _noise = "0";

  String _selectedHistoryShow = "temperature";
  String _unitDataShow = "℃";

  String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    _loadInitialBrightness(); // Load dữ liệu ban đầu từ Firebase
    listenForLastestDataAirSensor("temperature", "°C");
    listenForLastestDataAirSensor("humidity", "%");
    listenForLastestDataAirSensor("PM10", "μg/m³");
    listenForLastestDataAirSensor("PM2_5", "μg/m³");
    listenForLastestDataAirSensor("air_pressure", "Pa");
    listenForLastestDataAirSensor("ambient_light", "lux");
    listenForLastestDataAirSensor("noise", "dB");
  }

  Future<void> _loadInitialBrightness() async {
    try {
      DatabaseEvent event = await global_databaseReference
          .child(_deviceID)
          .child("Newest data")
          .once();

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

  void listenForLastestDataAirSensor(String dataName, String dataUnit) {
    global_databaseReference
        .child(_deviceID)
        .child(_stationID)
        .child(dataName)
        .child(today)
        .orderByKey()
        .limitToLast(1)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        Map<dynamic, dynamic> dataValue =
            event.snapshot.value as Map<dynamic, dynamic>;
        String latestKey = dataValue.keys.first;
        double latestValue = dataValue[latestKey];
        setState(() {
          if (dataName == 'temperature') {
            _temperatureValue = "$latestValue$dataUnit";
          } else if (dataName == 'humidity') {
            _humidityValue = "$latestValue$dataUnit";
          } else if (dataName == 'PM10') {
            _pm10 = "$latestValue $dataUnit";
          } else if (dataName == 'PM2_5') {
            _pm2_5 = "$latestValue $dataUnit";
          } else if (dataName == 'air_pressure') {
            _airPressure = "$latestValue $dataUnit";
          } else if (dataName == 'ambient_light') {
            _ambientLight = "$latestValue $dataUnit";
          } else if (dataName == 'noise') {
            _noise = "$latestValue $dataUnit";
          } else {
            print("Wrong data name");
          }
        });
      }
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
                      border:
                          Border.all(color: const Color(0xFFE6E5F2), width: 1),
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
                                      inactiveTrackColor:
                                          const Color(0xFFF4EEF4),
                                      trackShape:
                                          const RoundedRectSliderTrackShape(),
                                      trackHeight: 45.0,
                                      thumbShape: const RoundSliderThumbShape(
                                          enabledThumbRadius: 25),
                                      overlayColor: Colors.blue.withAlpha(10),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
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
                                child: _buildButton("NEMA - ESP32", context,
                                    pageIndex: 2),
                              ),
                              Positioned(
                                top: 130,
                                left: 70,
                                child: _buildButton("CAMERA", context,
                                    pageIndex: 4),
                              ),
                              Positioned(
                                top: 130,
                                right: 110,
                                child: _buildButton("AIR SENSOR", context,
                                    pageIndex: 6),
                              ),
                              Positioned(
                                top: 335,
                                right: 110,
                                child: _buildButton("SCREEN", context,
                                    pageIndex: 5),
                              ),
                              Positioned(
                                top: 500,
                                right: 110,
                                child: _buildButton("CHARGER", context,
                                    pageIndex: 7),
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
                                    'Physical information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight
                                          .w600, // Đặt fontWeight bên trong TextStyle
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                    onPressed: () {
                                      print('Refresh button pressed');
                                      //TODO: Refresh button pressed
                                    },
                                    icon: Image.asset(
                                        'lib/assets/icons/refresh_icon.png',
                                        height: 30),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
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
                                      border: Border.all(
                                          color: Color(0xFFE6E5F2), width: 1),
                                      borderRadius: BorderRadius.circular(28),
                                      color: Color(0xFF3ACBE9),
                                    ),
                                    child: buildSwitchPoleWidget(
                                      isOn: _isSwitched, // Initial state
                                      onToggle: (bool value) {
                                        // Handle the toggle logic here
                                        setState(() {
                                          _isSwitched = value;
                                        });
                                        print("Streetlight toggled: $value");
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFE6E5F2), width: 1),
                                      borderRadius: BorderRadius.circular(28),
                                      color: Color(0xFFF2946D),
                                    ),
                                    child: buildEnvShowWidget(
                                      label: "Temperature",
                                      value: _temperatureValue,
                                      icon: Icons.thermostat,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color(0xFFE6E5F2), width: 1),
                                      borderRadius: BorderRadius.circular(28),
                                      color: Color(0xFF6F5CEA),
                                    ),
                                    child: buildEnvShowWidget(
                                      label: "Humidity",
                                      value: _humidityValue,
                                      icon: Icons.opacity,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          flex: 33,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFFE6E5F2), width: 1),
                              borderRadius: BorderRadius.circular(28),
                              color: const Color(0xFFFFFFFF),
                            ),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start, // Align text
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Align the column vertically
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(50, 0, 40, 0),
                                  child: Text(
                                    'Air quality',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IntrinsicHeight(
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 80),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center, // Align text
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // Align the column vertically
                                            children: [
                                              buildEnvSensorInfo(
                                                  'lib/assets/svg/air-pressure.svg',
                                                  _airPressure,
                                                  'Air pressure'),
                                              buildEnvSensorInfo(
                                                  'lib/assets/svg/brightness.svg',
                                                  _ambientLight,
                                                  'Luminous'),
                                              buildEnvSensorInfo(
                                                  'lib/assets/svg/sound.svg',
                                                  _noise,
                                                  'Noise'),
                                            ],
                                          ),
                                        ),
                                      ),
                                      VerticalDivider(
                                        width: 30,
                                        thickness: 5,
                                        color: Colors.black,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 80),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center, // Align text
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // Align the column vertically
                                            children: [
                                              buildAirQualityInfo(
                                                'lib/assets/svg/pm1_0.svg',
                                                '100.52 μg/m³',
                                              ),
                                              buildAirQualityInfo(
                                                'lib/assets/svg/pm2_5.svg',
                                                _pm2_5,
                                              ),
                                              buildAirQualityInfo(
                                                'lib/assets/svg/pm4_0.svg',
                                                '100.52 μg/m³',
                                              ),
                                              buildAirQualityInfo(
                                                'lib/assets/svg/pm10.svg',
                                                _pm10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
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
                                      fontWeight: FontWeight
                                          .w600, // Đặt fontWeight bên trong TextStyle
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  child: DropdownButtonWidget(
                                    label: "Temperature",
                                    onOptionSelected:
                                        handleHistoryChartSelection,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 30,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Color(0xFFE6E5F2), width: 1),
                              borderRadius: BorderRadius.circular(28),
                              color: Color(0xFFFFFFFF),
                            ),
                            child: LineChartWidget(
                              key: ValueKey(_selectedHistoryShow),
                              deviceId: _deviceID,
                              stationId: _stationID,
                              sensorType: _selectedHistoryShow,
                              unitData: _unitDataShow,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  } // Widget build

  Widget buildSwitchPoleWidget({
    required bool isOn,
    required Function(bool) onToggle,
  }) =>
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'lib/assets/svg/lamp.svg',
                  width: 45,
                  height: 45,
                  // ignore: deprecated_member_use
                  color: Colors.white,
                ),
                SizedBox(width: 20),
                Text(
                  isOn ? 'ON' : 'OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: isOn, // Pass the toggle state
                  onChanged: onToggle, // Callback for switch toggling
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.black54, // Color when ON
                  inactiveThumbColor: Colors.white70, // Color when OFF
                  inactiveTrackColor: Colors.grey, // Background when OFF
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                'Street light',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildEnvShowWidget({
    required String label,
    required String value,
    required IconData icon,
  }) =>
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 45,
                ),
                SizedBox(
                  width: 40,
                ),
                Text(
                  '$value',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildEnvSensorInfo(
    String iconPath,
    String value,
    String label,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 140,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Align text
                mainAxisAlignment:
                    MainAxisAlignment.center, // Align the column vertically
                children: [
                  SvgPicture.asset(
                    iconPath,
                    width: 40,
                    height: 40,
                    color: Colors.black,
                  ),
                  Text(
                    label,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ), // Column
            ), // Sized Box

            Text(
              '$value',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ), // Row
      );

  Widget buildAirQualityInfo(
    String svgPath,
    String value,
  ) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SvgPicture.asset(
              svgPath,
              width: 40,
              height: 40,
              // color: Colors.black,
            ),
            SizedBox(
              width: 30,
            ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );

  void handleHistoryChartSelection(String newSelection) {
    setState(() {
      if (newSelection == "Temperature") {
        _selectedHistoryShow = "temperature";
        _unitDataShow = "℃";
      } else if (newSelection == "Humidity") {
        _selectedHistoryShow = "humidity";
        _unitDataShow = "%";
      } else if (newSelection == "Luminous") {
        _selectedHistoryShow = "ambient_light";
        _unitDataShow = "Lux";
      }
    });
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
  } // build
}
