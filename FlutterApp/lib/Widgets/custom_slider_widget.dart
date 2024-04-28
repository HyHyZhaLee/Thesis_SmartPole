// custom_slider_widget.dart
import 'package:flutter/material.dart';

class CustomSliderWidget extends StatefulWidget {
  final double initialSliderValue;
  final Function(double) onValueChanged;

  const CustomSliderWidget({
    Key? key,
    this.initialSliderValue = 43,
    required this.onValueChanged,
  }) : super(key: key);

  @override
  _CustomSliderWidgetState createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<CustomSliderWidget> {
  late double _currentSliderValue;
  late bool _isSwitched;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.initialSliderValue;
    _isSwitched = _currentSliderValue > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 16),
          Text(
            _isSwitched ? '${_currentSliderValue.round()}%' : 'Off',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: _isSwitched ? Colors.black : Colors.grey,
            ),
          ),
          Expanded(
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
                  onChanged: _isSwitched
                      ? (value) {
                    setState(() {
                      _currentSliderValue = value;
                      widget.onValueChanged(_currentSliderValue);
                    });
                  }
                      : null,
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
                _currentSliderValue = _isSwitched ? 100 : 0;
                widget.onValueChanged(_currentSliderValue);
              });
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
