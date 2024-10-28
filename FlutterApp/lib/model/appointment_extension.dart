import 'dart:convert';
import 'dart:html' as html;
import 'package:syncfusion_flutter_calendar/calendar.dart';

extension AppointmentJson on Appointment {
  String toString2(DateTime date) {
    String y = date.year.toString();
    String m = date.month.toString();
    String d = date.day.toString();
    String h = date.hour.toString();
    String min = date.minute.toString();
    String sec = date.second.toString();
    String ms = date.millisecond.toString();
    return "$d-$m-$y $h:$min:$sec.$ms";
  }

  Map<String, dynamic> toJson() => {
        'subject': subject,
        'description': notes,
        'startDate': toString2(startTime),
        'endDate': toString2(endTime),
        'recurrenceRule': recurrenceRule,
      };
}

void saveAppointmentToFile(List<Appointment> appointments, String key) async {
  final List<Map<String, dynamic>> jsonMap =
      appointments.map((appointment) => appointment.toJson()).toList();
  final jsonString = jsonEncode(jsonMap);

  html.window.localStorage[key] = jsonString;
}
