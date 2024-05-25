import 'package:flutter/material.dart';

class SensorDataBox extends StatelessWidget {
  final String sensorName;
  final String iconPath;
  final String sensorData;

  const SensorDataBox({
    Key? key,
    required this.sensorName,
    required this.iconPath,
    required this.sensorData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color.fromARGB(44, 164, 167, 189), // Màu nền giống SmartDeviceBox khi tắt
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // icon
              Image.asset(
                iconPath,
                height: 65,
                color: Colors.grey.shade700,
              ),

              // sensor name + data
              Column(
                children: [
                  Text(
                    sensorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    sensorData,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
