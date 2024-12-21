import 'package:flutter/material.dart';

class SmartPoleDashBoard extends StatefulWidget {
  const SmartPoleDashBoard({super.key});

  @override
  _SmartPoleDashBoardState createState() => _SmartPoleDashBoardState();
}

class _SmartPoleDashBoardState extends State<SmartPoleDashBoard> {
  final Map<String, String> partInformation = {
    'NEMA - ESP32': 'Information about NEMA - ESP32',
    'Air Sensor': 'Information about Air Sensor',
    'Camera': 'Information about Camera',
    'Screen': 'Information about Screen',
    'Charger': 'Information about Charger',
  };

  String selectedPart = ''; // Store the name of the selected part

  void selectPart(String part) {
    setState(() {
      selectedPart = part;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Define the size of the smart pole image based on screen size
    final imageWidth = screenWidth * 0.4; // 40% of screen width
    final imageHeight = screenHeight * 0.8; // 80% of screen height

    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          // Left side (Smart Pole Image and Part Labels with lines)
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                // Custom Paint for lines
                CustomPaint(
                  size: Size(imageWidth, imageHeight),
                  painter:
                      LinePainter(imageWidth, imageHeight), // Pass dynamic size
                ),
                // Smart Pole Image
                Image.asset(
                  'assets/images/smart_pole.png', // Assuming this is the image path
                  width: imageWidth,
                  height: imageHeight,
                ),
                // Clickable labels for parts (positions relative to the image size)
                Positioned(
                  top: imageHeight * 0.1, // 10% from top
                  left: imageWidth * 0.3, // 30% from left
                  child: GestureDetector(
                    onTap: () => selectPart('NEMA - ESP32'),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.grey.withOpacity(0.8),
                      child: const Text('NEMA - ESP32'),
                    ),
                  ),
                ),
                Positioned(
                  top: imageHeight * 0.25, // 25% from top
                  left: imageWidth * 0.5, // 50% from left
                  child: GestureDetector(
                    onTap: () => selectPart('Air Sensor'),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.grey.withOpacity(0.8),
                      child: const Text('Air Sensor'),
                    ),
                  ),
                ),
                Positioned(
                  top: imageHeight * 0.4, // 40% from top
                  left: imageWidth * 0.1, // 10% from left
                  child: GestureDetector(
                    onTap: () => selectPart('Camera'),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.grey.withOpacity(0.8),
                      child: const Text('Camera'),
                    ),
                  ),
                ),
                Positioned(
                  top: imageHeight * 0.55, // 55% from top
                  left: imageWidth * 0.6, // 60% from left
                  child: GestureDetector(
                    onTap: () => selectPart('Screen'),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.grey.withOpacity(0.8),
                      child: const Text('Screen'),
                    ),
                  ),
                ),
                Positioned(
                  top: imageHeight * 0.8, // 80% from top
                  left: imageWidth * 0.2, // 20% from left
                  child: GestureDetector(
                    onTap: () => selectPart('Charger'),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      color: Colors.grey.withOpacity(0.8),
                      child: const Text('Charger'),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right side (Information Display)
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedPart.isNotEmpty ? selectedPart : 'Select a part',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    selectedPart.isNotEmpty
                        ? partInformation[selectedPart] ??
                            'No information available'
                        : 'Click on a part to see details.',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter to draw lines connecting labels to the smart pole image
class LinePainter extends CustomPainter {
  final double imageWidth;
  final double imageHeight;

  LinePainter(this.imageWidth, this.imageHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0;

    // Define the start and end points for each line, relative to image size
    final nemaEsp32Start = Offset(imageWidth * 0.3 + 20, imageHeight * 0.1 + 5);
    final nemaEsp32End =
        Offset(imageWidth * 0.4, imageHeight * 0.08); // Adjust end point

    final airSensorStart =
        Offset(imageWidth * 0.5 + 20, imageHeight * 0.25 + 5);
    final airSensorEnd =
        Offset(imageWidth * 0.55, imageHeight * 0.2); // Adjust end point

    final cameraStart = Offset(imageWidth * 0.1 + 20, imageHeight * 0.4 + 5);
    final cameraEnd =
        Offset(imageWidth * 0.15, imageHeight * 0.35); // Adjust end point

    final screenStart = Offset(imageWidth * 0.6 + 20, imageHeight * 0.55 + 5);
    final screenEnd =
        Offset(imageWidth * 0.65, imageHeight * 0.5); // Adjust end point

    final chargerStart = Offset(imageWidth * 0.2 + 20, imageHeight * 0.8 + 5);
    final chargerEnd =
        Offset(imageWidth * 0.25, imageHeight * 0.75); // Adjust end point

    // Draw lines
    canvas.drawLine(nemaEsp32Start, nemaEsp32End, paint);
    canvas.drawLine(airSensorStart, airSensorEnd, paint);
    canvas.drawLine(cameraStart, cameraEnd, paint);
    canvas.drawLine(screenStart, screenEnd, paint);
    canvas.drawLine(chargerStart, chargerEnd, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
