import 'package:flutter/material.dart';

class DropdownButtonWidget extends StatefulWidget {
  final void Function(String)
      onOptionSelected; // Callback to pass the selected option

  const DropdownButtonWidget({
    Key? key,
    required String label,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  _DropdownButtonWidgetState createState() => _DropdownButtonWidgetState();
}

class _DropdownButtonWidgetState extends State<DropdownButtonWidget> {
  // Danh sách các tùy chọn
  final List<String> options = ['Temperature', 'Humidity', 'Noise'];

  // Giá trị được chọn
  String selectedOption = 'Temperature';

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFFEDEEF4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        value: selectedOption,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Color(0xFF333333),
        ),
        underline: SizedBox(), // Ẩn dòng gạch chân của DropdownButton
        onChanged: (String? newValue) {
          setState(() {
            selectedOption = newValue!;
            widget.onOptionSelected(
                newValue); // Trigger the callback with the new value
          });
        },
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF333333),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
