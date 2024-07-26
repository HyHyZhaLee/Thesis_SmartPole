import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class AddEventDialog {
  static Future<void> show(BuildContext context, Function(Appointment) onAddEvent) async {
    final eventNameController = TextEditingController();
    final notesController = TextEditingController();
    final intervalController = TextEditingController();
    final rtimesController = TextEditingController();
    DateTimeRange dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
    DateTime? startDate;
    DateTime? endDate;
    int? durationDate;
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    String? recurrenceType;

    final List<String> recurrenceTypeItems = [
      'None',
      'Daily',
      'Weekly',
      'Monthly',
      'Yearly',
    ];

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: const Center(
                  child: Text(
                    'Add New Event',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40.0,
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              content: SizedBox(
                width: 440,
                height: 400,
                child: SingleChildScrollView(
                  child: IntrinsicWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: eventNameController,
                          decoration: const InputDecoration(
                            labelText: 'Event Name',
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                        const SizedBox(height: 20),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(240, 60),
                            // maximumSize: const ,
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            elevation: 2.0,
                          ),
                          onPressed: () async {
                            DateTimeRange? pickedDate = await showDateRangePicker(
                              context: context,
                              initialDateRange: dateRange,
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Center(
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 500,
                                      maxHeight: 600,
                                    ),
                                    child: Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        // side: const BorderSide(),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.white),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8), // slightly less than 30 to avoid overflow
                                          child: child,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                            if (pickedDate != null) {
                              setState(() {
                                startDate = pickedDate.start;
                                endDate = pickedDate.end;
                                durationDate = pickedDate.duration.inDays;
                                dateRange = pickedDate;
                              });
                            }
                          },

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                'Start Date - End Date',
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: startDate == null ? 32.0 : 16.0,
                                  decoration: startDate == null
                                      ? TextDecoration.none
                                      : TextDecoration.underline,
                                ),
                              ),
                              if (durationDate != null) ...[
                                Text(
                                  startDate != null
                                      ? '${DateFormat('dd/MM/yyyy').format(startDate!)} - '
                                      'Period: $durationDate Day(s)'
                                      : 'Start Date - End Date',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w900,
                                    height: 1,
                                  ),
                                )
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 60),
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                elevation: 2.0,
                              ),
                              onPressed: () async {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null && pickedTime != startTime) {
                                  setState(() {
                                    startTime = pickedTime;
                                  });
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text(
                                    "Start Time",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: startTime == null ? 32.0 : 16.0,
                                      decoration: startTime == null
                                          ? TextDecoration.none
                                          : TextDecoration.underline,
                                    ),
                                  ),
                                  if (startTime != null) ...[
                                    Text(
                                      startTime!.format(context),
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w900,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            const Text(
                              ' - ',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 32.0,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 60),
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(8)),
                                ),
                                elevation: 2.0,
                              ),
                              onPressed: () async {
                                final pickedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (pickedTime != null && pickedTime != endTime) {
                                  setState(() {
                                    endTime = pickedTime;
                                  });
                                }
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "End Time",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: endTime == null ? 32.0 : 16.0,
                                      decoration: endTime == null
                                          ? TextDecoration.none
                                          : TextDecoration.underline,
                                    ),
                                  ),
                                  if (endTime != null) ...[
                                    Text(
                                      endTime!.format(context),
                                      style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w900,
                                        height: 1,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              DropdownMenu<String>(
                                width: 200,
                                initialSelection: 'None',
                                textStyle: const TextStyle(
                                  fontSize: 20.0,
                                ),
                                label: const Text(
                                  'Select Recurrence Type',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                ),
                                dropdownMenuEntries: recurrenceTypeItems.map((String item) {
                                  return DropdownMenuEntry<String>(
                                    value: item,
                                    label: item,
                                  );
                                }).toList(),
                                onSelected: (String? newValue) {
                                  setState(() {
                                    recurrenceType = newValue!;
                                  });
                                },
                              ),
                              if (recurrenceType != 'None' && recurrenceType != null) ...[
                                SizedBox(width: 10,),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Center(
                                      child: TextField(
                                        controller: rtimesController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: 'RTimes',
                                          hintStyle: TextStyle(
                                            textBaseline: TextBaseline.ideographic,
                                            color: Colors.grey,
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          // alignLabelWithHint: true,
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              if (recurrenceType == 'Daily' || recurrenceType == 'Weekly' || recurrenceType == 'Monthly') ...[
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Center(
                                      child: TextField(
                                        controller: intervalController,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          hintText: 'Interval',
                                          hintStyle: TextStyle(
                                            textBaseline: TextBaseline.ideographic,
                                            color: Colors.grey,
                                          ),
                                          floatingLabelBehavior: FloatingLabelBehavior.always,
                                          // alignLabelWithHint: true,
                                          border: InputBorder.none,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),


                        const SizedBox(height: 10),
                        TextField(
                          controller: notesController,
                          decoration: const InputDecoration(
                            labelText: 'Notes',
                            labelStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            alignLabelWithHint: true,
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  onPressed: () {
                    if (startTime != null && endTime != null) {
                      final DateTime startDateTime = DateTime(
                        startDate!.year,
                        startDate!.month,
                        startDate!.day,
                        startTime!.hour,
                        startTime!.minute,
                      );
                      final DateTime endDateTime = DateTime(
                        endDate!.year,
                        endDate!.month,
                        endDate!.day,
                        endTime!.hour,
                        endTime!.minute,
                      );
                      String recurrenceRule = '';
                      int interval = int.tryParse(intervalController.text) ?? 1;
                      if (recurrenceType != 'None') {
                        switch (recurrenceType) {
                          case 'Daily':
                            recurrenceRule = 'FREQ=DAILY;INTERVAL=$interval';
                            break;
                          case 'Weekly':
                            recurrenceRule =
                            'FREQ=WEEKLY;BYDAY=${DayOfWeekUtils.getDayOfWeek(startDate!)};INTERVAL=$interval;COUNT=3';
                            break;
                          case 'Monthly':
                            recurrenceRule =
                            'FREQ=MONTHLY;BYMONTHDAY=${dateRange.start.day};INTERVAL=$interval';
                            break;
                          case 'Yearly':
                            recurrenceRule =
                            'FREQ=YEARLY;BYMONTH=${startDate!.month};BYMONTHDAY=${startDate!.day}';
                            break;
                        }
                      }
                      final newEvent = Appointment(
                        startTime: startDateTime,
                        endTime: endDateTime,
                        subject: eventNameController.text,
                        notes: notesController.text,
                        recurrenceRule: recurrenceRule,
                        color: Colors.blue,
                      );
                      onAddEvent(newEvent);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class DayOfWeekUtils {
  static String getDayOfWeek(DateTime date) {
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
}
