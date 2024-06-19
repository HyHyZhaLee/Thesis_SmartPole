import 'package:intl/intl.dart';

String getCurrentTimestamp() {
  final now = DateTime.now().toUtc().add(Duration(hours: 7)); // GMT+7
  final formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  return '${formatter.format(now)} GMT+0700';
}