import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/AppFunction/get_event_details.dart';
import 'package:flutter_app/widgets/navigation_drawer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_app/utils/convertDateTime.dart';

class AddEventPage extends StatefulWidget {
  final Appointment? newAppoitment;

  const AddEventPage({
    Key? key,
    this.newAppoitment,
  }) : super (key:key);

  @override
  _AddEventPageStage createState() => _AddEventPageStage();
}

class _AddEventPageStage extends State<AddEventPage>{
  final _formKey = GlobalKey<FormState>();
  final eventNameController = TextEditingController();
  final notesController = TextEditingController();
  final intervalController = TextEditingController();
  final rtimesController = TextEditingController();

  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    super.initState();
    if (widget.newAppoitment == null) {
      startDate = DateTime.now();
      endDate = DateTime.now().add( const Duration(hours: 2));
    }
  }

  @override
  void dispose(){
    eventNameController.dispose();
    notesController.dispose();
    intervalController.dispose();
    rtimesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Dialog(
    insetPadding: EdgeInsets.all(4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    shadowColor: Colors.grey,
    elevation: 8,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 3.0,
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Form(
        key: _formKey,
        child: bodyAddEventDialog(),
      ),
    ),
  );

  Widget bodyAddEventDialog() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Expanded(
        flex: 1,
        child: buildAddTitle(),
      ),
      Spacer(flex:1),
      Expanded(
        flex: 1,
        child: buildEventName(),
      ),
      // Expanded(
      //   flex: 1,
      //   child: buildStart(),
      // ),
      // Expanded(
      //   flex: 1,
      //   child:
      // ),
      // Expanded(
      //   flex: 1,
      //   child: buildEnd(),
      // ),
      // Expanded(
      //   flex: 1,
      //   child: buildRecurrenceRule(),
      // ),
      // Expanded(
      //   child: buildLink(),
      // )
      Spacer(flex: 3,),
    ],
  );

  Widget buildAddTitle() => Container(
    width: MediaQuery.of(context).size.width * 0.5,
    height: MediaQuery.of(context).size.height * 0.1,
    decoration: BoxDecoration(
      color: Colors.deepPurpleAccent,
      borderRadius: BorderRadius.circular(8),
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
  );

  Widget buildEventName() => Container(
    width: MediaQuery.of(context).size.width * 0.6,
    height:  MediaQuery.of(context).size.height * 0.1,
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(8),
    ),
    child: TextFormField(
      validator: (name) =>
          name != null && name.isEmpty ? 'Name event cannot be empty' : null,
      controller: eventNameController,
      decoration: const InputDecoration(
        hintText: 'Event Name',
        labelStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: const TextStyle(
        fontSize: 20.0,
      ),
    ),
  );

  Widget buildStart() => Container(
    width: MediaQuery.of(context).size.width * 0.6,
    height:  MediaQuery.of(context).size.height * 0.1,
    decoration: BoxDecoration(
      color: Colors.grey,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Expanded(
          child: buildDropdownField(
            text: convertReadableDateTime.toDate(startDate),
            onClicked: () {},
          ),
        ),
        Expanded(
          child: buildDropdownField(
            text: convertReadableDateTime.toTime(startDate),
            onClicked: () {},
          ),
        ),
      ],
    ),
  );

  Widget buildDropdownField({
    required String text,
    required VoidCallback onClicked,
  }) =>
      Container(
        decoration: BoxDecoration(

        ),
        child: ListTile(
          title: Text(text),
          trailing: Icon(Icons.arrow_drop_down_circle_rounded),
          onTap: onClicked,
        ),
      )


} // class _AddEventPageStage



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
                      int interval =  int.tryParse(intervalController.text) ?? 1;
                      int? repeatTimes = int.tryParse(rtimesController.text);
                      if (recurrenceType != 'None') {
                        switch (recurrenceType) {
                          case 'Daily':
                            recurrenceRule = 'FREQ=DAILY;INTERVAL=$interval';
                            break;
                          case 'Weekly':
                            recurrenceRule =
                            'FREQ=WEEKLY;BYDAY=${DayOfWeekUtils.getDayOfWeek(startDate!)};INTERVAL=$interval';
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

                        if (repeatTimes != null && repeatTimes > 0)
                        {
                          recurrenceRule += ';COUNT=$repeatTimes';
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
