import 'package:flutter/material.dart';
import 'package:flutter_app/model/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventProvider extends ChangeNotifier {
  final List<Event> _events = [];

  List<Event> get events => _events;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  void addEvent(Event event) {
    _events.add(event);

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