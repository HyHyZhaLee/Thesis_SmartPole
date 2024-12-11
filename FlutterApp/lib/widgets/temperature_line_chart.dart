import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../AppFunction/global_variables.dart';

class LineChartWidget extends StatefulWidget {
  final String deviceId;
  final String stationId;
  final String sensorType;
  final String date;

  LineChartWidget({
    Key? key,
    required this.deviceId,
    required this.stationId,
    required this.sensorType,
    String? date,
  })  : date = date ??
            DateFormat('yyyy-MM-dd')
                .format(DateTime.now()), // Assign default if null
        super(key: key);

  @override
  _LineChartWidgetState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  List<FlSpot> _spots = [];

  @override
  void initState() {
    super.initState();
    global_databaseReference
        .child(widget.deviceId)
        .child(widget.stationId)
        .child(widget.sensorType)
        .child(widget.date)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        final dataMap = Map<String, double>.from(event.snapshot.value as Map);
        List<FlSpot> spots = [];
        dataMap.forEach((key, value) {
          // Convert time string (HH:mm:ss) to minutes since midnight
          spots.add(FlSpot(_convertTimeToFloat(key), value));
        });
        setState(() {
          _spots = spots
            ..sort((a, b) =>
                a.x.compareTo(b.x)); // Ensure the spots are ordered by time
        });
      }
    });
  }

  double _convertTimeToFloat(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    return hours * 60.0 +
        minutes +
        seconds / 60.0; // Convert time to total minutes
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // Enable horizontal scrolling
      child: Container(
        width: 1000, // Set a fixed width for the container that holds the chart
        child: LineChart(
          LineChartData(
            minY: 20.0,
            maxY: 40.0,
            lineTouchData: LineTouchData(
              touchTooltipData:
                  LineTouchTooltipData(getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.y}', // Display y value
                    TextStyle(
                        color: Colors.blue,
                        fontWeight:
                            FontWeight.bold), // Customize text style here
                  );
                }).toList();
              }),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey[300],
                  strokeWidth: 1.0,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.grey[300],
                  strokeWidth: 1.0,
                );
              },
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    // Format the X-axis labels
                    return Text(
                        DateFormat('HH:mm').format(DateTime.now()
                            .add(Duration(minutes: value.toInt()))),
                        style: TextStyle(color: Colors.black, fontSize: 10));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (double value, TitleMeta meta) {
                    // Format the Y-axis labels
                    return Text(value.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 10));
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.grey[300]!, width: 1),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: _spots,
                isCurved: true,
                color: Colors.red, // Line color
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.red.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
