import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_app/widgets/add_event_dialog.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_app/widgets/event_details_dialog.dart';
import 'package:flutter_app/utils/custom_route.dart';
import 'package:flutter_app/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/widgets/app_bar_custom.dart';
import 'package:flutter_app/model/appointment_extension.dart';

class LightingSchedulePage extends StatefulWidget {
  const LightingSchedulePage({super.key});

  @override
  _LightingSchedulePage createState() => _LightingSchedulePage();
}

class _LightingSchedulePage extends State<LightingSchedulePage> {
  late List<CustomAppointment> _appointments;
  CalendarView _calendarView = CalendarView.month;
  late CustomAppointmentDataSource _calendarDataSource;

  @override
  void initState() {
    super.initState();
    // Set up listener to update appointments from provider
    final provider =
        Provider.of<CustomAppointmentProvider>(context, listen: false);
    _appointments = provider.appointments;
    _calendarDataSource = CustomAppointmentDataSource(_appointments);

    // Add a listener to provider changes
    provider.addListener(updateAppointments);
  }

  void updateAppointments() {
    final provider =
        Provider.of<CustomAppointmentProvider>(context, listen: false);
    setState(() {
      _appointments = provider.appointments;
      _calendarDataSource = CustomAppointmentDataSource(_appointments);
    });
  }

  @override
  void dispose() {
    Provider.of<CustomAppointmentProvider>(context, listen: false)
        .removeListener(updateAppointments);
    super.dispose();
  }

  // Future<void> _loadAppointments() async {
  //   final String response =
  //       await rootBundle.loadString('assets/jsonfile/data.json');
  //   final List<dynamic> jsonData = json.decode(response);
  //   for (var event in jsonData) {
  //     _addAppointmentFromJson(event);
  //   }
  //   setState(() {
  //     _calendarDataSource = AdvertiseDataSource(_appointments);
  //   });
  // }

  // void _changeCalendarView(CalendarView view) {
  //   setState(() {
  //     _calendarView = view;
  //   });
  // }

  // void _addAppointmentFromJson(Map<String, dynamic> event) {
  //   final eventName = event['event_name'];
  //   final startDate = DateTime.parse(event['start_date']);
  //   final endDate = DateTime.parse(event['end_date']);
  //   final startTime = TimeOfDay(
  //     hour: int.parse(event['start_time'].split(':')[0]),
  //     minute: int.parse(event['start_time'].split(':')[1]),
  //   );
  //   final endTime = TimeOfDay(
  //     hour: int.parse(event['end_time'].split(':')[0]),
  //     minute: int.parse(event['end_time'].split(':')[1]),
  //   );
  //   final recurrenceType = event['recurrence_type'];
  //   final interval = event['interval'];
  //   final count = event['count'];
  //   final note = event['note'];

  //   final startDateTime = DateTime(
  //     startDate.year,
  //     startDate.month,
  //     startDate.day,
  //     startTime.hour,
  //     startTime.minute,
  //   );
  //   final endDateTime = DateTime(
  //     endDate.year,
  //     endDate.month,
  //     endDate.day,
  //     endTime.hour,
  //     endTime.minute,
  //   );

  //   String recurrenceRule = '';
  //   if (recurrenceType != 'None') {
  //     switch (recurrenceType) {
  //       case 'Daily':
  //         recurrenceRule = 'FREQ=DAILY;INTERVAL=$interval;COUNT=$count';
  //         break;
  //       case 'Weekly':
  //         recurrenceRule =
  //             'FREQ=WEEKLY;BYDAY=${_getDayOfWeek(startDate)};INTERVAL=$interval;COUNT=$count';
  //         break;
  //       case 'Monthly':
  //         recurrenceRule =
  //             'FREQ=MONTHLY;BYMONTHDAY=${startDate.day};INTERVAL=$interval;COUNT=$count';
  //         break;
  //       case 'Yearly':
  //         recurrenceRule =
  //             'FREQ=YEARLY;BYMONTH=${startDate.month};BYMONTHDAY=${startDate.day};INTERVAL=$interval;COUNT=$count';
  //         break;
  //     }
  //   }

  //   final appointment = Appointment(
  //     startTime: startDateTime,
  //     endTime: endDateTime,
  //     subject: eventName,
  //     notes: note,
  //     recurrenceRule: recurrenceRule,
  //     color: Colors.blue,
  //   );
  //   _appointments.add(appointment);
  // }

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
        dataSource: _calendarDataSource,
        allowDragAndDrop: false,
        showNavigationArrow: false,
        showDatePickerButton: true,
        showTodayButton: true,
        allowViewNavigation: false,
        showCurrentTimeIndicator: true,
        allowAppointmentResize: true,
        cellBorderColor: Colors.transparent,
        onTap: handleCalendarTap,
        monthViewSettings: const MonthViewSettings(
            showAgenda: true,
            agendaViewHeight: 200.0,
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurpleAccent,
        shape: const CircleBorder(),
        onPressed: () => Navigator.of(context)
            .push(AddEventPageRuote(page: const AddEventPage())),
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
    if (details.targetElement == CalendarElement.appointment &&
        details.appointments != null &&
        details.appointments!.isNotEmpty) {
      final CustomAppointment appointment = details.appointments!.first;
      EventDetailsDialog.show(
        context,
        appointment,
      );
    } else if (details.targetElement == CalendarElement.calendarCell &&
        details.date != null &&
        (details.appointments == null || details.appointments!.isEmpty)) {
      if (kDebugMode) {
        print("Tapped on Date: ${details.date}");
      }
      // Here you can handle other actions like navigating to an add event page
      navigateToAddEventPage(context, details.date);
    }
  }

  void navigateToAddEventPage(BuildContext context, DateTime? selectedDate) {
    if (selectedDate != null) {
      Navigator.of(context).push(AddEventPageRuote(
          page: AddEventPage(
        date: selectedDate,
      )));
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

  // List<CustomAppointment> getAppointments() {
  //   List<CustomAppointment> meetings = <CustomAppointment>[];
  //   final DateTime today = DateTime.now();
  //   final DateTime startTime =
  //       DateTime(today.year, today.month, today.day, 9, 0, 0);
  //   final DateTime endTime = startTime.add(const Duration(hours: 2));

  //   return meetings;
  // }
}
