import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_app/widgets/custom_button_choosing_date.dart';
import 'package:flutter_app/AppFunction/get_event_details.dart';
import 'package:flutter_app/widgets/add_event_dialog.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

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
          recurrenceRule = 'FREQ=DAILY;INTERVAL=$interval';
          break;
        case 'Weekly':
          recurrenceRule = 'FREQ=WEEKLY;BYDAY=${_getDayOfWeek(startDate)};INTERVAL=$interval';
          break;
        case 'Monthly':
          recurrenceRule = 'FREQ=MONTHLY;BYMONTHDAY=${startDate.day};INTERVAL=$interval';
          break;
        case 'Yearly':
          recurrenceRule = 'FREQ=YEARLY;BYMONTH=${startDate.month};BYMONTHDAY=${startDate.day};INTERVAL=$interval';
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
        onTap: _handleCalendarTap,
        monthViewSettings: const MonthViewSettings(
          appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        shape: const CircleBorder(),
        onPressed: () => AddEventDialog.show(context, (newEvent) {
          setState(() {
            _appointments.add(newEvent);
          });
          _changeCalendarView(CalendarView.month);
        }),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void _handleCalendarTap(CalendarTapDetails details) {
    if (details.targetElement == CalendarElement.appointment) {
      final Appointment appointment = details.appointments!.first;
      _showEventDetailsDialog(context, appointment);
      if (_calendarView == CalendarView.month) {
        setState(() {
          _calendarView = CalendarView.day;
        });
      }
    }
    if (details.targetElement == CalendarElement.calendarCell){

    }
  }

  Future<void> _showEventDetailsDialog(
      BuildContext context, Appointment appointment) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Center(
              child: Text(
                appointment.subject,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [               
                      Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.access_time,
                          color: Colors.blue,
                        ),
                      ) ,
                      Spacer(flex: 1),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              GetEventsDetails.formatDate(appointment.startTime),
                            ),
                          ],
                        ),
                      ),
                      Spacer(flex: 2),
                      Container(
                        color: Colors.grey,
                        width: 2,
                      ),
                      Spacer(flex: 2),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Start Time:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              GetEventsDetails.formatTime(appointment.startTime),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                
                _buildDetailRow(
                  Icons.access_time, 
                  'Start Time',
                  GetEventsDetails.formatDate(appointment.startTime),
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  Icons.access_time_outlined, 
                  'End Time',
                  appointment.endTime.toString()
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  Icons.repeat, 
                  'Recurrence Rule', 
                  GetEventsDetails.recurrenceRuleParser(appointment.recurrenceRule),
                ),
                const SizedBox(height: 10),
                _buildDetailRow(
                  Icons.notes, 
                  'Notes', 
                  appointment.notes ?? 'None'
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _appointments.remove(appointment);
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        );
      },
    );
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
