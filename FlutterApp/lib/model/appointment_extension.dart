import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';
import 'package:intl/intl.dart';
import 'dart:html' as html;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CustomAppointment extends Appointment {
  String? firebaseKey;

  CustomAppointment({
    required super.subject,
    required super.startTime,
    required super.endTime,
    this.firebaseKey = '',
    String notes = '',
    super.color = Colors.blue,
  }) : super(
          notes: notes,
        );

  Map<String, dynamic> toJson(DateTime timeStamp) {
    return {
      'station_id': "SmartPole_0002",
      'station_name': "Smart Pole 0002",
      'device_id': "NEMA_0002",
      'data': {
        'startTime':
            "${DateFormat("dd-MM-yyyy HH:mm:ss").format(startTime)} GMT+0700",
        'endTime':
            "${DateFormat("dd-MM-yyyy HH:mm:ss").format(endTime)} GMT+0700",
        'description': notes,
        'color': color.value,
      },
      'timestamp':
          "${DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now())} GMT+0700"
    };
  }

  // Generate a random Firebase key
  String generateFirebaseKey() {
    var rng = Random();
    var key = List.generate(20, (index) => rng.nextInt(100).toString()).join();
    firebaseKey = key;
    return key;
  }

  Future<void> saveToFirebase() async {
    if (kDebugMode) {
      print("triggering firebase");
    }

    // Tham chiếu đến node "Schedule light"
    var pushRef =
        global_databaseReference.child('NEMA_0002').child('Schedule light');

    try {
      // Lấy dữ liệu của lịch mới nhất
      DatabaseEvent newestScheduleEvent = await pushRef.once();

      String newScheduleName;
      if (newestScheduleEvent.snapshot.value != null &&
          newestScheduleEvent.snapshot.value is Map) {
        // Lấy danh sách các tên lịch (các key)
        Map<String, dynamic> schedules = Map<String, dynamic>.from(
            newestScheduleEvent.snapshot.value as Map);
        List<String> scheduleNames = schedules.keys.toList();

        // Sắp xếp danh sách tên lịch theo thứ tự giảm dần
        scheduleNames.sort((a, b) => b.compareTo(a));

        // Tên lịch mới nhất
        String newestScheduleName = scheduleNames.first;

        // Cộng thêm 1 vào lịch mới nhất
        int newestNumber =
            int.tryParse(newestScheduleName.replaceAll(RegExp(r'\D'), '')) ?? 0;
        newScheduleName = 'Schedule ${newestNumber + 1}';
      } else {
        // Nếu chưa có lịch nào, đặt tên cho lịch đầu tiên
        newScheduleName = 'Schedule 1';
      }

      // Ghi dữ liệu mới vào Firebase
      var newScheduleRef = pushRef.child(newScheduleName);
      await newScheduleRef.set(toJson(DateTime.now())).then((_) {
        if (kDebugMode) {
          print('Data successfully written with key ${newScheduleRef.key}');
        }
      }).catchError((error) {
        if (kDebugMode) {
          print('Error writing data: $error');
        }
      });

      // Lưu lại key của lịch mới
      firebaseKey = newScheduleRef.key;
    } catch (error) {
      if (kDebugMode) {
        print('Error occurred: $error');
      }
    }
  }

  // Factory constructor to create a CustomAppointment from JSON
  factory CustomAppointment.fromJson(Map<String, dynamic> json) {
    // Parse the date using the known format
    DateTime parseDate(String date) {
      return DateFormat("dd-MM-yyyy HH:mm:ss").parse(date.split(" GMT")[0]);
    }

    return CustomAppointment(
      firebaseKey: json['data'][0]['firebaseKey'] as String,
      startTime: parseDate(json['data'][0]['startTime']),
      endTime: DateTime.parse(json['data'][0]['endTime'] as String),
      subject: json['data'][0]['subject'] as String? ?? '',
      notes: json['data'][0]['description'] as String? ?? '',
      color: Color(json['data'][0]['color'] as int),
    );
  }
}

class CustomAppointmentDataSource extends CalendarDataSource {
  CustomAppointmentDataSource(List<CustomAppointment> appointments) {
    this.appointments = appointments;
  }

  CustomAppointment getAppointment(int index) =>
      appointments![index] as CustomAppointment;

  @override
  DateTime getStartTime(int index) => getAppointment(index).startTime;

  @override
  DateTime getEndTime(int index) => getAppointment(index).endTime;

  @override
  String getSubject(int index) => getAppointment(index).subject;

  @override
  Color getColor(int index) => getAppointment(index).color;
}

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
