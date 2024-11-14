import 'package:flutter/material.dart';
import 'package:flutter_app/model/appointment_extension.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomAppointmentProvider extends ChangeNotifier {
  final List<CustomAppointment> _appointments = [];

  List<CustomAppointment> get appointments => _appointments;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  void addAppointment(CustomAppointment event) {
    _appointments.add(event);

    notifyListeners();
  }
}

class AppointmentProvider extends ChangeNotifier {
  final List<Appointment> _appoinments = [];

  List<Appointment> get appointments => _appoinments;

  DateTime _selectedDate = DateTime.now();

  DateTime get selaectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  void addAppointment(Appointment appointment) {
    _appoinments.add(appointment);

    notifyListeners();
  }
}
