import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/appointment_extension.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomAppointmentProvider extends ChangeNotifier {
  final List<CustomAppointment> _appointments = [];

  List<CustomAppointment> get appointments => _appointments;

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void addAppointment(CustomAppointment event) {
    _appointments.add(event);

    notifyListeners();
  }

  void deleteAppointment(CustomAppointment appointment) {
    final ref = global_databaseReference
        .child('NEMA_0002')
        .child("Schedule light")
        .child(appointment.firebaseKey!);

    ref.remove();

    _appointments.remove(appointment);
    notifyListeners();
  }

  void editAppointment(
      CustomAppointment newAppointment, CustomAppointment oldAppointment) {
    final index = _appointments.indexOf(oldAppointment);
    _appointments[index] = newAppointment;

    notifyListeners();
  }

  Future<void> loadAppointmentsFromFirebase() async {
    try {
      final snapshot = await global_databaseReference
          .child("NEMA_0002")
          .child("Schedule light")
          .get();

      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        final List<CustomAppointment> loadedAppointments = [];

        data.forEach((key, value) {
          final eventData = value as Map<dynamic, dynamic>;
          loadedAppointments.add(CustomAppointment(
            startTime: DateTime.parse(eventData['startTime']),
            endTime: DateTime.parse(eventData['endTime']),
            subject: eventData['name_event'],
            firebaseKey: key, // Save the Firebase key for future reference
            color: Color(int.parse(
                eventData['color'])), // Assuming color is stored as an integer
          ));
        });

        _appointments.clear();
        _appointments.addAll(loadedAppointments);
        notifyListeners();
      }
    } catch (error) {
      print("Error loading appointments from Firebase: $error");
    }
  }

  void listenForRealtimeUpdates() {
    final ref =
        global_databaseReference.child('NEMA_0002').child('Schedule light');

    // Listen for data changes at the reference
    ref.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;

      if (data != null && data is Map<dynamic, dynamic>) {
        final List<CustomAppointment> updatedAppointments = [];

        // Iterate over the map and convert to CustomAppointment objects
        data.forEach((key, value) {
          final appointmentData = value as Map<dynamic, dynamic>;
          final appointmentJson =
              appointmentData['data'] as Map<dynamic, dynamic>;

          updatedAppointments.add(CustomAppointment(
            firebaseKey: key,
            startTime: DateFormat("dd-MM-yyyy HH:mm:ss")
                .parse(appointmentJson['startTime'].split(" GMT")[0]),
            endTime: DateFormat("dd-MM-yyyy HH:mm:ss")
                .parse(appointmentJson['endTime'].split(" GMT")[0]),
            subject: appointmentJson['description'] ?? 'No Title',
            color: Color(int.parse(appointmentJson['color'].toString())),
          ));
        });

        // Update the local appointments list
        _appointments.clear();
        _appointments.addAll(updatedAppointments);

        // Notify listeners to update the UI
        notifyListeners();
      }
    }, onError: (error) {
      if (kDebugMode) {
        print("Error listening for updates: $error");
      }
    });
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
