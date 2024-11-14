import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/AppFunction/global_variables.dart';
import 'package:flutter_app/provider/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_app/utils/convertDateTime.dart';
import 'package:flutter_app/model/recurrence_type.dart';
import 'package:flutter_app/utils/convert_datetime_recurencerule.dart';
import 'package:flutter_app/model/appointment_extension.dart';

class TextSizes {
  static const double titleSize = 32.0;
  static const double headerSize = 20.0;
  static const double bodyTextSize = 16.0;
  static const double subBodyTextSize = 12.0;

  static const String titleFont = 'None';
  static const String headerFont = 'None';
  static const String bodyTextFont = 'None';
}

class AddEventPage extends StatefulWidget {
  final CustomAppointment? appointment;
  final DateTime? date;

  const AddEventPage({
    super.key,
    this.appointment,
    this.date,
  });

  @override
  _AddEventPageStage createState() => _AddEventPageStage();
}

class _AddEventPageStage extends State<AddEventPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DateTime _startTime;
  late DateTime _endTime;

  TextEditingController _subjectController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.appointment == null && widget.date == null) {
      _startTime = DateTime.now();
      _endTime = _startTime.add(const Duration(hours: 2));
    } else if (widget.appointment == null && widget.date != null) {
      _startTime = widget.date!;
      _endTime = widget.date!.add(const Duration(hours: 2));
    } else {
      final appointment = widget.appointment!;
      if (kDebugMode) {
        print("editing triggered");
      }
      _subjectController =
          TextEditingController(text: widget.appointment!.subject);
      _notesController = TextEditingController(text: widget.appointment!.notes);
      _startTime = appointment.startTime;
      _endTime = appointment.endTime;
    }
  }

  @override
  void dispose() {
    _subjectController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.all(4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadowColor: Colors.grey,
        elevation: 8,
        surfaceTintColor: Colors.black,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.4,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 3.0,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: bodyAddEventDialog(),
        ),
      );

  Widget bodyAddEventDialog() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 3,
            child: buildAddTitle(),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 3,
            child: buildEventName(),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 3,
            child: buildHeader(
              header: 'START:',
              child: buildStart(),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 3,
            child: buildHeader(
              header: 'END:',
              child: buildEnd(),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          // Expanded(
          //   flex: 5,
          //   child: buildRecurrenceRule2(),
          // ),
          Expanded(
            flex: 5,
            child: buildHeader(
              header: 'NOTES:',
              child: buildNote(),
            ),
          ),
          const Spacer(flex: 1),
          Expanded(
            flex: 1,
            child: buildCancelSaveButton(),
          ),
        ],
      );

  Widget buildAddTitle() => Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Center(
            child: Text(
              'ADD NEW EVENT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: TextSizes.titleSize,
              ),
            ),
          ),
        ),
      );

  Widget buildEventName() => Padding(
        padding: const EdgeInsets.fromLTRB(
          50,
          0,
          50,
          0,
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: TextFormField(
              textAlign: TextAlign.center,
              validator: (name) => name != null && name.isEmpty
                  ? 'Name event cannot be empty'
                  : null,
              controller: _subjectController,
              onFieldSubmitted: (_) => saveForm(),
              decoration: const InputDecoration(
                hintText: 'Event Name',
                labelStyle: TextStyle(
                  fontSize: TextSizes.headerSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: const TextStyle(
                fontSize: TextSizes.headerSize,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      );

  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              color: Colors.white,
              child: Text(
                header,
                style: const TextStyle(
                  fontSize: TextSizes.headerSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Expanded(child: child),
          ],
        ),
      );

  Widget buildStart() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.transparent,
              ),
              child: buildDropdownField(
                text: convertReadableDateTime.toDate(_startTime),
                onClicked: () => pickStartDateTime(pickDate: true),
              ),
            ),
          ),
          const Spacer(flex: 1),
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: Colors.transparent,
              ),
              child: buildDropdownField(
                text: convertReadableDateTime.toTime(_startTime),
                onClicked: () => pickStartDateTime(pickDate: false),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
        ],
      );

  Future pickStartDateTime({
    required bool pickDate,
  }) async {
    final date = await pickDateTime(_startTime, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(_endTime)) {
      _endTime = DateTime(
          date.year, date.month, date.day, _endTime.hour, _endTime.minute);
    }

    setState(() => _startTime = date);
  }

  Widget buildEnd() => Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.transparent,
              ),
              child: buildDropdownField(
                text: convertReadableDateTime.toDate(_endTime),
                onClicked: () => pickEndDateTime(pickDate: true),
              ),
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
            flex: 3,
            child: buildDropdownField(
              text: convertReadableDateTime.toTime(_endTime),
              onClicked: () => pickEndDateTime(pickDate: false),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.01,
          ),
        ],
      );

  Future pickEndDateTime({
    required bool pickDate,
  }) async {
    final date = await pickDateTime(
      _endTime,
      pickDate: pickDate,
      firstDate: pickDate ? _startTime : null,
    );
    if (date == null) return;

    setState(() => _endTime = date);
  }

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            alignment: Alignment.topCenter,
            elevation: 4,
            shadowColor: Colors.grey,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.all(16),
            side: const BorderSide(
              color: Colors.black,
              width: 1.0,
            ),
          ),
          onPressed: onClicked,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: TextSizes.bodyTextSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Icon(Icons.arrow_drop_down_circle_outlined),
            ],
          ),
        ),
      );

  Future<DateTime?> pickDateTime(
    DateTime initialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2101),
        builder: (context, child) => customDatePickerBuilder(context, child),
      );

      if (date == null) return null;
      final time =
          Duration(hours: initialDate.hour, minutes: initialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );
      if (timeOfDay == null) return null;

      final date =
          DateTime(initialDate.year, initialDate.month, initialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

      return date.add(time);
    }
  }

  Widget customDatePickerBuilder(BuildContext context, Widget? child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors
                .deepPurpleAccent, // Changes the color of the header and selected date
            onPrimary: Colors.white, // Changes the text color of the header
            onSurface: Colors.black, // Changes the color of dates
          ),
          dialogBackgroundColor:
              Colors.white, // Changes the background color of the dialog
          dialogTheme: DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Adjust rounding here
            ),
          ),
        ),
        child: child!,
      );

  Widget buildNote() => TextField(
        controller: _notesController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Border color
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Border color when focused
              width: 2.0, // Border width when focused
            ),
            borderRadius:
                BorderRadius.circular(12), // Optional: Adjust border radius
          ),
          labelStyle: const TextStyle(
            fontSize: TextSizes.bodyTextSize,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          alignLabelWithHint: true,
        ),
        maxLines: 4,
      );

  Widget buildCancelSaveButton() => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buildCancelButton(),
            const SizedBox(
              width: 8,
            ),
            buildAddButton(),
          ],
        ),
      );

  Widget buildCancelButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: Colors.grey,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text(
          'Cancel',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget buildAddButton() => ElevatedButton(
        onPressed: saveForm,
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shadowColor: Colors.grey,
          backgroundColor: Colors.deepPurpleAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(8),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  // String? _handleRecurrenceRule() {
  //   String? recType;
  //   if (recurrenceFlag != repeatOptionItems[0]) {
  //     switch (recurrenceType) {
  //       case 'Day':
  //         recType = 'FREQ=DAILY';
  //       case 'Week':
  //         recType =
  //             'FREQ=WEEKLY;BYDAY=${DayOfWeekUtils.getDayOfWeek(startDate)}';
  //       case 'Month':
  //         recType = 'FREQ=MONTHLY;BYMONTHDAY=${startDate.day}';
  //       case 'Year':
  //         recType = 'FREQ=YEARLY;BYMONTH=${startDate.month}';
  //       default:
  //         recType = 'FREQ=DAILY';
  //     }

  //     recType += ';INTERVAL=${recurrenceIntervalController.text}';

  //     if (isCheckedRecurrenceCount != false) {
  //       recType += ';COUNT=${recurrenceCountController.text}';
  //     }
  //   }
  //   return recType;
  // }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      CustomAppointment appointment = CustomAppointment(
        subject: _subjectController.text,
        notes: _notesController.text,
        startTime: _startTime,
        endTime: _endTime,
        color: Colors.blue,
        // recurrenceRule: _handleRecurrenceRule(),
      );
      final isEditing = widget.appointment != null;
      print(isEditing);

      final provider =
          Provider.of<CustomAppointmentProvider>(context, listen: false);

      if (isEditing) {
        DatabaseReference ref = global_databaseReference
            .child("Schedule light")
            .child("name_event: ${widget.appointment!.subject}")
            .child("${widget.appointment!.firebaseKey}");
        ref.remove();

        provider.editAppointment(appointment, widget.appointment!);

        appointment.saveToFirebase();
      } else {
        provider.addAppointment(appointment);
        appointment.saveToFirebase();
      }

      Navigator.of(context).pop();
    }
  }
} // class _AddEventPageStage


