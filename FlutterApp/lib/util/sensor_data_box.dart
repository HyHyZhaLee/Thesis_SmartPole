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
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            height: 60,
            color: Colors.grey[800],
          ),
          SizedBox(height: 16),
          Text(
            sensorName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            sensorData,
            style: TextStyle(
              fontSize: 24,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
