import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Slider',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Custom Vertical Slider'),
        ),
        body: CustomSliderWidget(),
      ),
    );
  }
}

class CustomSliderWidget extends StatefulWidget {
  @override
  _CustomSliderWidgetState createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  double _currentSliderValue = 43;
  bool _isSwitched = true; // Assuming the light is on initially

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 16), // Reduced space
          Text(
            _isSwitched ? '${_currentSliderValue.round()}%' : 'Off',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _isSwitched ? Colors.black : Colors.grey,
              // fontFamily: 'YourCustomFont', // Uncomment this when you add your font
            ),
          ),
          Expanded( // Make the slider take up all available space
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Color(0xFF4C9FED),
                  inactiveTrackColor: Color(0xFFF4EEF4),
                  trackShape: RoundedRectSliderTrackShape(),
                  trackHeight: 70.0,
                  thumbShape: RoundSliderThumbShape(enabledThumbRadius: 35),
                  overlayColor: Colors.blue.withAlpha(32),
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 60),
                ),
                child: Slider(
                  value: _currentSliderValue,
                  min: 0,
                  max: 100,
                  onChanged: _isSwitched ? (value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  } : null, // Disable the slider when the power is off
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: _isSwitched ? Color(0xFF4C9FED) : Color(0xFFF4EEF4),
              size: 70.0,
            ),
            onPressed: () {
              setState(() {
                _isSwitched = !_isSwitched;
                if (!_isSwitched) {
                  _currentSliderValue = 0; // Turn off the light
                }
                else if (_isSwitched){
                  _currentSliderValue = 100;
                }
              });
            },
          ),
          SizedBox(height: 16), // Space before the bottom of the column
        ],
      ),
    );
  }
}
