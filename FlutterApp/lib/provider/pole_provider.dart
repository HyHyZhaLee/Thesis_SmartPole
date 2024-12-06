import 'package:flutter/material.dart';
import 'package:flutter_app/model/pole.dart';

class PoleProvider extends ChangeNotifier {
  String _selectedPole = poles[0];

  String get selectedPole => _selectedPole;

  void setSelectedPole(String pole) {
    _selectedPole = pole;
    notifyListeners();
  }
}
