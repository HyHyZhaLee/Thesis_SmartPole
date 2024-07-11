import 'package:flutter/material.dart';

class SensorDataBox extends StatelessWidget {
  final String sensorName;
  final String iconPath;
  final String sensorData;

  const SensorDataBox({
    super.key,
    required this.sensorName,
    required this.iconPath,
    required this.sensorData,
  });

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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sensorData,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
