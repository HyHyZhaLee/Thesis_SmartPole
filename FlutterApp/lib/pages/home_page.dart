import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/util/smart_device_box.dart';
import 'package:flutter_app/util/sensor_data_box.dart'; // Import thêm file này

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // padding constants
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  // list of smart devices
  List mySmartDevices = [
    // [ smartDeviceName, iconPath , powerStatus ]
    ["NEMA 0001", "lib/icons/light-bulb.png", false],
    ["NEMA 0002", "lib/icons/light-bulb.png", false],
  ];

  // list of sensor data
  List mySensors = [
    // Image path: svgrepo.com; thickness = 45%
    // [ sensorName, iconPath , sensorData ]
    ["Temperature", "lib/icons/temperature.png", "22°C"],
    ["Humidity", "lib/icons/humidity.png", "54%"],
    ["PM1.0", "lib/icons/pm1_0.png", "25 µg/m³"],
    ["PM2.5", "lib/icons/pm25.png", "15 µg/m³"],
    ["PM4.0", "lib/icons/pm40.png", "12 µg/m³"],
    ["PM10", "lib/icons/pm10.png", "10 µg/m³"],
    ["CO2", "lib/icons/co2.png", "450 ppm"],
  ];

  // power button switched
  void powerSwitchChanged(bool value, int index) {
    setState(() {
      mySmartDevices[index][2] = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // app bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menu icon
                  Image.asset(
                    'lib/icons/menu.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),

                  // account icon
                  Image.asset(
                    'lib/icons/Logo-DH-Bach-Khoa-HCMUT.png',
                    height: 45,
                    // color: Colors.grey[800],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // welcome home
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Capstone Project",
                    style: TextStyle(fontSize: 20, color: Colors.grey.shade800),
                  ),
                  Text(
                    'SMART POLE',
                    style: GoogleFonts.bebasNeue(fontSize: 72),
                  ),
                ],
              ),
            ),

            SizedBox(height: 25),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.0),
              child: Divider(
                thickness: 1,
                color: Color.fromARGB(255, 204, 204, 204),
              ),
            ),

            SizedBox(height: 25),

            // smart devices grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Text(
                "Smart Devices",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            SizedBox(height: 10),

            // smart devices grid and sensor data grid combined
            SizedBox(
              height: 600, // Đặt chiều cao cụ thể cho GridView
              child: GridView.builder(
                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: mySmartDevices.length + mySensors.length,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  if (index < mySmartDevices.length) {
                    return SmartDeviceBox(
                      smartDeviceName: mySmartDevices[index][0],
                      iconPath: mySmartDevices[index][1],
                      powerOn: mySmartDevices[index][2],
                      onChanged: (value) => powerSwitchChanged(value, index),
                    );
                  } else {
                    int sensorIndex = index - mySmartDevices.length;
                    return SensorDataBox(
                      sensorName: mySensors[sensorIndex][0],
                      iconPath: mySensors[sensorIndex][1],
                      sensorData: mySensors[sensorIndex][2],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
