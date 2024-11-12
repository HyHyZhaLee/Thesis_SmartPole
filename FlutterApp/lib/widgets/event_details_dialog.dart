import 'package:flutter/material.dart';
import 'package:flutter_app/model/appointment_extension.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_app/AppFunction/get_event_details.dart'; // Import the file where GetEventsDetails is defined

class EventDetailsDialog {
  static Future<void> show(
    BuildContext context,
    CustomAppointment appointment,
    Function(Appointment) onDelete,
  ) async {
    const double bodyFontSize = 20;
    const double headerFontSize = 20;
    const double subjectFontSize = 36;
    const double iconSize = 36;
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
                  fontSize: subjectFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    width: 310,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            color: Colors.white,
                            child: const Icon(
                              Icons.access_time,
                              color: Colors.blue,
                              size: iconSize,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Start Date:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: headerFontSize,
                                  ),
                                ),
                                Text(
                                  GetEventsDetails.formatDate(
                                      appointment.startTime),
                                  style: const TextStyle(
                                    fontSize: bodyFontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'End Date:',
                                  style: TextStyle(
                                    fontSize: headerFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  GetEventsDetails.formatDate(
                                      appointment.endTime),
                                  style: const TextStyle(
                                    fontSize: bodyFontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 10,
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: Colors.white,
                          child: const Icon(
                            Icons.access_time_outlined,
                            color: Colors.blue,
                            size: iconSize,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Start Time:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: headerFontSize,
                                ),
                              ),
                              Text(
                                GetEventsDetails.formatTime(
                                    appointment.startTime),
                                style: const TextStyle(
                                  fontSize: bodyFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'End Time:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: headerFontSize,
                                ),
                              ),
                              Text(
                                GetEventsDetails.formatTime(
                                    appointment.endTime),
                                style: const TextStyle(
                                  fontSize: bodyFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 10,
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: Colors.white,
                          child: const Icon(
                            Icons.repeat,
                            color: Colors.blue,
                            size: 36,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: IntrinsicWidth(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Recurrence Rule:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: headerFontSize,
                                      ),
                                    ),
                                    Text(
                                      GetEventsDetails.recurrenceRuleParser(
                                          appointment.recurrenceRule),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: bodyFontSize,
                                      ),
                                    )
                                  ],
                                ),
                                const Divider(
                                  height: 10,
                                  thickness: 2,
                                ),
                                IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Interval:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: headerFontSize,
                                              ),
                                            ),
                                            Text(
                                              (GetEventsDetails.recurrenceInterval(
                                                              appointment
                                                                  .recurrenceRule) !=
                                                          null &&
                                                      GetEventsDetails
                                                              .recurrenceInterval(
                                                                  appointment
                                                                      .recurrenceRule)! >
                                                          0)
                                                  ? '1'
                                                  : GetEventsDetails
                                                          .recurrenceInterval(
                                                              appointment
                                                                  .recurrenceRule)
                                                      .toString(),
                                              style: const TextStyle(
                                                fontSize: bodyFontSize,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Repeat Times:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: headerFontSize,
                                              ),
                                            ),
                                            Text(
                                              (GetEventsDetails.recurrenceCount(
                                                              appointment
                                                                  .recurrenceRule) !=
                                                          null &&
                                                      GetEventsDetails
                                                              .recurrenceCount(
                                                                  appointment
                                                                      .recurrenceRule)! >
                                                          0)
                                                  ? GetEventsDetails
                                                          .recurrenceCount(
                                                              appointment
                                                                  .recurrenceRule)
                                                      .toString()
                                                  : 'Infinity',
                                              style: const TextStyle(
                                                fontSize: bodyFontSize,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    height: 10,
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: Colors.white,
                          child: const Icon(
                            Icons.notes,
                            color: Colors.blue,
                            size: iconSize,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Notes:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: headerFontSize,
                                ),
                              ),
                              Text(
                                '${appointment.notes}',
                                style: const TextStyle(
                                  fontSize: bodyFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: headerFontSize,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                // Assuming you have access to _appointments and setState here
                onDelete(appointment);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: headerFontSize,
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
