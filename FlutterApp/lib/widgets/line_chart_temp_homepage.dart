import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(MaterialApp(home: TemperatureChart()));
}

class TemperatureChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Temperature History')),
      body: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 23,
          minY: 26.0,
          maxY: 36.0,
          lineBarsData: [
            LineChartBarData(
              spots: [
                // Replace these with your actual data points
                FlSpot(0, 26.5),
                FlSpot(1, 27.0),
                FlSpot(3, 28.0),
                FlSpot(5, 30.0),
                FlSpot(7, 34.0),
                FlSpot(9, 34.5),
                FlSpot(12, 35.0),
                FlSpot(15, 34.5),
                FlSpot(18, 32.0),
                FlSpot(21, 29.5),
                FlSpot(23, 26.5),
              ],
              isCurved: true,
              color: Colors.purple,
              barWidth: 5,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
