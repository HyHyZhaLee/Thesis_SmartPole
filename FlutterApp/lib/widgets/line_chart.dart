import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class _LineChart extends StatelessWidget {
  const _LineChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(lineChartData);
  }

  LineChartData get lineChartData => LineChartData();

  LineTouchData lineTouchData() => const LineTouchData();

  FlGridData gridData() => FlGridData();

  FlTitlesData titlesData() => FlTitlesData();

  FlBorderData borderData() => FlBorderData();

  List<LineChartBarData> lineBarsData() => [];
}
