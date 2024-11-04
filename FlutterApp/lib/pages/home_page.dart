import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/app_bar_custom.dart';
import 'package:flutter_app/widgets/smart_pole_dash_board.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SmartPoleAppBar(
        title: "Home Page", // Custom text
        titleStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SmartPoleDashBoard(),
    );
  }
}
