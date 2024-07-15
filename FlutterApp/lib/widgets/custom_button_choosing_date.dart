import 'package:flutter/material.dart';

class CustomColorOutlinedButton extends StatefulWidget {
  final String day;
  final ValueChanged<String> onButtonPressed;

  const CustomColorOutlinedButton({
    super.key,
    required this.day,
    required this.onButtonPressed,
  });

  @override
  _CustomColorButtonState createState() => _CustomColorButtonState();
}

class _CustomColorButtonState extends State<CustomColorOutlinedButton> {
  bool isClicked = false;

  void _toggleButtonColor() {
    setState(() {
      isClicked = !isClicked;
    });
    widget.onButtonPressed(widget.day);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _toggleButtonColor,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: isClicked ? Colors.green : Colors.blue, // Change color here
      ),
      child: Text(widget.day),
    );
  }
}

class ChoosingDayOfWeek extends StatefulWidget {
  final ValueChanged<String> onDaySelected;

  const ChoosingDayOfWeek ({
    super.key,
    required this.onDaySelected,
  });

  @override
  _ChoosingDayOfWeekState createState() => _ChoosingDayOfWeekState();
}

class _ChoosingDayOfWeekState extends State<ChoosingDayOfWeek> {
  String? selectedDay;

  void _handleDaySelection(String day) {
    setState(() {
      selectedDay = day;
    });
    widget.onDaySelected(day);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildDayButton('MO'),
        _buildDayButton('TU'),
        _buildDayButton('WE'),
        _buildDayButton('TH'),
        _buildDayButton('FR'),
        _buildDayButton('SA'),
        _buildDayButton('SU'),
      ],
    );
  }

  Widget _buildDayButton(String day) {
    return ElevatedButton(
      onPressed: () => _handleDaySelection(day),
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedDay == day ? Colors.green : Colors.blue,
      ),
      child: Text(day),
    );
  }
}
