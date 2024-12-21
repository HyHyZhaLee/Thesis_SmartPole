import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';
import 'package:flutter_app/model/appointment_extension.dart';
import 'package:flutter_app/utils/custom_route.dart';
import 'package:flutter_app/AppFunction/get_event_details.dart'; // Import the file where GetEventsDetails is defined
import 'package:flutter_app/widgets/add_event_dialog.dart';
import 'package:flutter_app/provider/event_provider.dart';
import 'package:provider/provider.dart';

class EventDetailsDialog {
  static Future<void> show(
    BuildContext context,
    CustomAppointment appointment,
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
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: headerFontSize,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(AddEventPageRuote(
                    page: AddEventPage(appointment: appointment)));
              },
            ),
            TextButton(
              onPressed: () {
                // Assuming you have access to _appointments and setState here
                Provider.of<CustomAppointmentProvider>(context, listen: false)
                    .deleteAppointment(appointment);

                // ignore: use_build_context_synchronously
                Navigator.of(context).pop(); // Close the dialog
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Appointment deleted successfully')),
                );
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

  static void deleteAppointment(
      BuildContext context, CustomAppointment appointment) {
    // Assuming Firebase has been initialized in the main.dart or similar global scope
    if (kDebugMode) {
      print(appointment.firebaseKey);
    }
    DatabaseReference ref = global_databaseReference
        .child("Schedule light")
        .child("name_event: ${appointment.subject}")
        .child("${appointment.firebaseKey}");

    print("${appointment.firebaseKey}");
    print("name_event: ${appointment.subject}");

    ref.remove().then((_) {
      if (kDebugMode) {
        print("Deleted appointment from Firebase successfully");
      }
      // Now remove from the local list
      // ignore: use_build_context_synchronously
      Provider.of<CustomAppointmentProvider>(context, listen: false)
          .deleteAppointment(appointment);

      // ignore: use_build_context_synchronously
      Navigator.of(context).pop(); // Close the dialog
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Appointment deleted successfully')),
      );
    }).catchError((error) {
      if (kDebugMode) {
        print("Failed to delete appointment from Firebase: $error");
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete appointment')),
      );
    });
  }
}
