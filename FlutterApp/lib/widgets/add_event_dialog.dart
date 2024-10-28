import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final Appointment? newAppoitment;

  const AddEventPage({
    super.key,
    this.newAppoitment,
  });

  @override
  _AddEventPageStage createState() => _AddEventPageStage();
}

class _AddEventPageStage extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  final eventNameController = TextEditingController();
  final notesController = TextEditingController();

  final recurrenceIntervalController = TextEditingController(text: '1');
  final recurrenceCountController = TextEditingController(text: '1');

  late DateTime startDate;
  late DateTime endDate;
  late String recurrenceFlag;
  late String recurrenceType;
  late bool isCheckedRecurrenceCount;

  late bool isDropdownEnabled;

  @override
  void initState() {
    super.initState();
    if (widget.newAppoitment == null) {
      startDate = DateTime.now();
      endDate = DateTime.now().add(const Duration(hours: 2));

      recurrenceFlag = 'Don\'t repeat';
      recurrenceType = 'Week';
      isCheckedRecurrenceCount = false;

      isDropdownEnabled = false;
    }
  }

  @override
  void dispose() {
    eventNameController.dispose();
    notesController.dispose();

    recurrenceCountController.dispose();
    recurrenceIntervalController.dispose();

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
          Expanded(
            flex: 5,
            child: buildRecurrenceRule2(),
          ),
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
              controller: eventNameController,
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
                text: convertReadableDateTime.toDate(startDate),
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
                text: convertReadableDateTime.toTime(startDate),
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
    final date = await pickDateTime(startDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(endDate)) {
      endDate = DateTime(
          date.year, date.month, date.day, endDate.hour, endDate.minute);
    }

    setState(() => startDate = date);
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
                text: convertReadableDateTime.toDate(endDate),
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
              text: convertReadableDateTime.toTime(endDate),
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
      endDate,
      pickDate: pickDate,
      firstDate: pickDate ? startDate : null,
    );
    if (date == null) return;

    setState(() => endDate = date);
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

  Widget buildRecurrenceRule2() => Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.12,
                  color: Colors.white,
                  child: buildReccurenceFlag(),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.07,
                  color: Colors.white,
                  child: Opacity(
                    opacity: recurrenceFlag != repeatOptionItems[0] ? 1.0 : 0.3,
                    child: buildReccurenceInterval(),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.01,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.08,
                  color: Colors.white,
                  child: Opacity(
                    opacity: recurrenceFlag != repeatOptionItems[0] ? 1.0 : 0.3,
                    child: buildReccurenceType(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          buildReccurenceCount(),
        ],
      );

  Widget buildReccurenceFlag() => DropdownButtonFormField<String>(
        value: repeatOptionItems[0],
        items: repeatOptionItems.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            if (newValue != null) {
              recurrenceFlag = newValue;
            } else {
              recurrenceFlag = 'Don\'t repeat';
            }
          });
        },
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Border color
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Border color when focused
              width: 2.0, // Border width when focused
            ), // Adjust the padding to reduce height
            borderRadius:
                BorderRadius.circular(24), // Optional: Adjust border radius
          ),
        ),
        style: const TextStyle(
          fontSize: TextSizes.bodyTextSize,
          fontWeight: FontWeight.bold, // Adjust font size to make it fit,
        ),
      );

  Widget buildReccurenceInterval() => TextFormField(
        enabled: recurrenceFlag != repeatOptionItems[0] ? true : false,
        controller: recurrenceIntervalController, // Controller
        keyboardType:
            TextInputType.number, // Makes the keyboard number-friendly
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter
              .digitsOnly, // Restricts input to numbers only
        ],
        textAlign: TextAlign.left,
        decoration: InputDecoration(
          hintText: 'Number',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w300,
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Border color
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Border color
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(24),
          ), // Adjust the padding to reduce height
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Border color when focused
              width: 2.0, // Border width when focused
            ),
            borderRadius:
                BorderRadius.circular(24), // Optional: Adjust border radius
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        style: const TextStyle(
          fontSize: TextSizes.bodyTextSize,
          fontWeight: FontWeight.bold,
          color: Colors.black, // Adjust font size to make it fit
        ),
      );

  Widget buildReccurenceType() => DropdownButtonFormField<String>(
        value: recurrenceTypeItems[1], // Default selected value
        items: recurrenceTypeItems.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: recurrenceFlag != repeatOptionItems[0]
            ? _handleDropdownChanged
            : null,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Border color
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.black, // Border color when focused
              width: 2.0, // Border width when focused
            ), // Adjust the padding to reduce height
            borderRadius:
                BorderRadius.circular(24), // Optional: Adjust border radius
          ),
        ),
        style: const TextStyle(
          fontSize: TextSizes.bodyTextSize,
          fontWeight: FontWeight.bold, // Adjust font size to make it fit
        ),
      );

  void _handleDropdownChanged(String? newValue) {
    setState(() {
      if (newValue != null) {
        recurrenceType = newValue;
      } else {
        recurrenceType = 'Week';
      }
    });
  }

  Widget buildReccurenceCount() => IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Opacity(
              opacity: recurrenceFlag != repeatOptionItems[0] ? 1.0 : 0.3,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.02,
                height: MediaQuery.of(context).size.height * 0.05,
                color: Colors.white,
                child: Checkbox(
                  value: isCheckedRecurrenceCount,
                  onChanged: recurrenceFlag != repeatOptionItems[0]
                      ? (newBool) {
                          setState(() {
                            if (newBool != null) {
                              isCheckedRecurrenceCount = newBool;
                            } else {
                              isCheckedRecurrenceCount = false;
                            }
                          });
                        }
                      : null,
                ),
              ),
            ),
            Opacity(
              opacity: recurrenceFlag != repeatOptionItems[0] &&
                      isCheckedRecurrenceCount != false
                  ? 1.0
                  : 0.3,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.height * 0.05,
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'After',
                    style: TextStyle(
                      fontSize: TextSizes.subBodyTextSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: recurrenceFlag != repeatOptionItems[0] &&
                      isCheckedRecurrenceCount != false
                  ? 1.0
                  : 0.3,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.05,
                height: MediaQuery.of(context).size.height * 0.05,
                color: Colors.white,
                child: TextFormField(
                  enabled: recurrenceFlag != repeatOptionItems[0] &&
                          isCheckedRecurrenceCount != false
                      ? true
                      : false,
                  keyboardType: TextInputType
                      .number, // Makes the keyboard number-friendly
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter
                        .digitsOnly, // Restricts input to numbers only
                  ],
                  controller: recurrenceCountController,
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color
                        width: 1.0, // Border width
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ), // Adjust the padding to reduce height
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.black, // Border color when focused
                        width: 2.0, // Border width when focused
                      ),
                      borderRadius: BorderRadius.circular(
                          24), // Optional: Adjust border radius
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  style: const TextStyle(
                    fontSize: TextSizes.bodyTextSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Adjust font size to make it fit
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: recurrenceFlag != repeatOptionItems[0] &&
                      isCheckedRecurrenceCount != false
                  ? 1.0
                  : 0.3,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.07,
                height: MediaQuery.of(context).size.height * 0.05,
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Occurrences',
                    style: TextStyle(
                      fontSize: TextSizes.subBodyTextSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget buildNote() => Container(
        width: MediaQuery.of(context).size.width * 0.6,
        height: MediaQuery.of(context).size.height * 0.1,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey, // Shadow color with opacity
              spreadRadius: 0, // How much the shadow spreads
              blurRadius: 4, // The blurring effect of the shadow
              offset: Offset(0, 2), // Offset in X and Y (horizontal, vertical)
            ),
          ],
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: notesController,
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
          maxLines: 3,
        ),
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
          'Add',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  String? _handleRecurrenceRule() {
    String? recType;
    if (recurrenceFlag != repeatOptionItems[0]) {
      switch (recurrenceType) {
        case 'Day':
          recType = 'FREQ=DAILY';
        case 'Week':
          recType =
              'FREQ=WEEKLY;BYDAY=${DayOfWeekUtils.getDayOfWeek(startDate)}';
        case 'Month':
          recType = 'FREQ=MONTHLY;BYMONTHDAY=${startDate.day}';
        case 'Year':
          recType = 'FREQ=YEARLY;BYMONTH=${startDate.month}';
        default:
          recType = 'FREQ=DAILY';
      }

      recType += ';INTERVAL=${recurrenceIntervalController.text}';

      if (isCheckedRecurrenceCount != false) {
        recType += ';COUNT=${recurrenceCountController.text}';
      }
    }
    return recType;
  }

  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final appointment = Appointment(
        subject: eventNameController.text,
        notes: notesController.text,
        startTime: startDate,
        endTime: endDate,
        color: Colors.blue,
        recurrenceRule: _handleRecurrenceRule(),
      );
      final provider = Provider.of<AppointmentProvider>(context, listen: false);
      provider.addAppointment(appointment);

      Navigator.of(context).pop();
    }
  }
} // class _AddEventPageStage


