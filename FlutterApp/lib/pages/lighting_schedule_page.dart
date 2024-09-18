import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_app/widgets/add_event_dialog.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_app/widgets/event_details_dialog.dart';
import 'package:flutter_app/utils/custom_route.dart';

class LightingSchedulePage extends StatefulWidget {
  const LightingSchedulePage({super.key});

  @override
  _LightingSchedulePage createState() => _LightingSchedulePage();
}

class _LightingSchedulePage extends State<LightingSchedulePage> {
  late List<Appointment> _appointments;
  CalendarView _calendarView = CalendarView.month;
  late CalendarDataSource _calendarDataSource;

  @override
  void initState() {
    super.initState();
    _appointments = getAppointments();
    _calendarDataSource = AdvertiseDataSource(_appointments);
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final String response = await rootBundle.loadString('/jsonfile/data.json');
    final List<dynamic> jsonData = json.decode(response);
    for (var event in jsonData) {
      _addAppointmentFromJson(event);
    }
    setState(() {
      _calendarDataSource = AdvertiseDataSource(_appointments);
    });
  }

  void _changeCalendarView(CalendarView view) {
    setState(() {
      _calendarView = view;
    });
  }

  void _addAppointmentFromJson(Map<String, dynamic> event) {
    final eventName = event['event_name'];
    final startDate = DateTime.parse(event['start_date']);
    final endDate = DateTime.parse(event['end_date']);
    final startTime = TimeOfDay(
      hour: int.parse(event['start_time'].split(':')[0]),
      minute: int.parse(event['start_time'].split(':')[1]),
    );
    final endTime = TimeOfDay(
      hour: int.parse(event['end_time'].split(':')[0]),
      minute: int.parse(event['end_time'].split(':')[1]),
    );
    final recurrenceType = event['recurrence_type'];
    final interval = event['interval'];
    final count = event['count'];
    final note = event['note'];

    final startDateTime = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      startTime.hour,
      startTime.minute,
    );
    final endDateTime = DateTime(
      endDate.year,
      endDate.month,
      endDate.day,
      endTime.hour,
      endTime.minute,
    );

    String recurrenceRule = '';
    if (recurrenceType != 'None') {
      switch (recurrenceType) {
        case 'Daily':
          recurrenceRule = 'FREQ=DAILY;INTERVAL=$interval;COUNT=$count';
          break;
        case 'Weekly':
          recurrenceRule = 'FREQ=WEEKLY;BYDAY=${_getDayOfWeek(startDate)};INTERVAL=$interval;COUNT=$count';
          break;
        case 'Monthly':
          recurrenceRule = 'FREQ=MONTHLY;BYMONTHDAY=${startDate.day};INTERVAL=$interval;COUNT=$count';
          break;
        case 'Yearly':
          recurrenceRule = 'FREQ=YEARLY;BYMONTH=${startDate.month};BYMONTHDAY=${startDate.day};INTERVAL=$interval;COUNT=$count';
          break;
      }
    }

    final appointment = Appointment(
      startTime: startDateTime,
      endTime: endDateTime,
      subject: eventName,
      notes: note,
      recurrenceRule: recurrenceRule,
      color: Colors.blue,
    );
    _appointments.add(appointment);
  }

  String _getDayOfWeek(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'MO';
      case DateTime.tuesday:
        return 'TU';
      case DateTime.wednesday:
        return 'WE';
      case DateTime.thursday:
        return 'TH';
      case DateTime.friday:
        return 'FR';
      case DateTime.saturday:
        return 'SA';
      case DateTime.sunday:
        return 'SU';
      default:
        return 'MO';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfCalendar(
        view: _calendarView,
        headerHeight: 50,
        headerStyle: const CalendarHeaderStyle(
          textStyle: TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.center,
          backgroundColor: Colors.blue,
        ),
        firstDayOfWeek: 1,
        dataSource: AdvertiseDataSource(_appointments),
        allowDragAndDrop: true,
        showNavigationArrow: false,
        showDatePickerButton: true,
        showTodayButton: true,
        allowViewNavigation: false,
        showCurrentTimeIndicator: true,
        allowAppointmentResize: true,
        cellBorderColor: Colors.transparent,
        onTap: handleCalendarTap,
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        shape: const CircleBorder(),
        onPressed: () => Navigator.of(context).push(
          AddEventPageRuote(page: AddEventPage())
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  // Widget addEventShowDialog() => Container(
  //         width: MediaQuery.of(context).size.width *0.5,
  //         height: MediaQuery.of(context).size.height *0.5,
  //         padding: const EdgeInsets.all(4),
  //         decoration:  BoxDecoration(
  //           color: Colors.blue,  // Content background is still white
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: AddEventPage(),
  //       );


  void handleCalendarTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      final Appointment appointment = details.appointments!.first;
      EventDetailsDialog.show(context, appointment, (Appointment appointmentToDelete) {
        setState(() {
          _appointments.remove(appointmentToDelete);
        });
      });
      if (_calendarView == CalendarView.month) {
        setState(() {
          _calendarView = CalendarView.day;
        });
      }
    }
  }


  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: Colors.blue,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Appointment> getAppointments() {
    List<Appointment> meetings = <Appointment>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));

    return meetings;
  }
}

class AdvertiseDataSource extends CalendarDataSource {
  AdvertiseDataSource(List<Appointment> source) {
    appointments = source;
  }
}
