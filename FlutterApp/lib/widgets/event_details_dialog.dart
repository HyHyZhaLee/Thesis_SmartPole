import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:flutter_app/AppFunction/get_event_details.dart'; // Import the file where GetEventsDetails is defined

class EventDetailsDialog {
  static Future<void> show(
    BuildContext context, 
    Appointment appointment,
    Function(Appointment) onDelete,
    ) async {
    final double bodyFontSize = 20;
    const double headerFontSize = 20;
    const double subjectFontSize = 36;
    final double iconSize = 36;
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
                  Container(
                    width: 310,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            color: Colors.white,
                            child: Icon(
                              Icons.access_time,
                              color: Colors.blue,
                              size: iconSize,
                            ),
                          ),
                          SizedBox(width: 15),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start Date:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: headerFontSize,
                                  ),
                                ),
                                Text(
                                  GetEventsDetails.formatDate(
                                      appointment.startTime),
                                  style: TextStyle(
                                    fontSize: bodyFontSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'End Date:',
                                  style: TextStyle(
                                    fontSize: headerFontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  GetEventsDetails.formatDate(appointment.endTime),
                                  style: TextStyle(
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
                  Divider(
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
                          child: Icon(
                            Icons.access_time_outlined,
                            color: Colors.blue,
                            size: iconSize,
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Start Time:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: headerFontSize,
                                ),
                              ),
                              Text(
                                GetEventsDetails.formatTime(appointment.startTime),
                                style: TextStyle(
                                  fontSize: bodyFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'End Time:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: headerFontSize,
                                ),
                              ),
                              Text(
                                GetEventsDetails.formatTime(appointment.endTime),
                                style: TextStyle(
                                  fontSize: bodyFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
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
                          child: Icon(
                            Icons.repeat,
                            color: Colors.blue,
                            size: 36,
                          ),
                        ),
                        SizedBox(width: 15),
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
                                    Text(
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
                                      style: TextStyle(
                                        fontSize: bodyFontSize,
                                      ),
                                    )
                                  ],
                                ),
                                Divider(
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
                                            Text(
                                              'Interval:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: headerFontSize,
                                              ),
                                            ),
                                            Text(
                                              (GetEventsDetails
                                                              .recurrenceInterval(
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
                                              style: TextStyle(
                                                fontSize: bodyFontSize,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
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
                                                      .recurrenceCount(appointment
                                                          .recurrenceRule)
                                                      .toString()
                                                  : 'Infinity',
                                              style: TextStyle(
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
                  Divider(
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
                          child: Icon(
                            Icons.notes,
                            color: Colors.blue,
                            size: iconSize,
                          ),
                        ),
                        SizedBox(width: 15),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notes:',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: headerFontSize,
                                ),
                              ),
                              Text(
                                '${appointment.notes}',
                                style: TextStyle(
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
