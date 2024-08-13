import 'package:intl/intl.dart';


class GetEventsDetails {
  static String recurrenceRuleParser (String? rule) {
    if (rule == null || rule.isEmpty){
      return 'None';
    }

    final Map<String, String> recurrenceMap = {
      'DAILY' : 'Daily',
      'WEAKLY': 'Weakly',
      'MONTHLY': 'Monthly',
      'YEARLY' : 'Yearly',
    };

    final List<String> ruleParts = rule.split(';');
    String frequency = 'None';
    for (String part in ruleParts) {
      if(part.startsWith('FREQ')) {
        final String freq = part.replaceFirst('FREQ=', '');
        frequency = recurrenceMap[freq] ?? frequency;
      }
    }
    return frequency;
  }

  static int? recurrenceCount(String? rule) {
    if (rule == null || rule.isEmpty) {
      return null;
    }

    final List<String> ruleParts = rule.split(';');
    for (String part in ruleParts) {
      if (part.startsWith('COUNT')) {
        final String count = part.replaceFirst('COUNT=', '');
        return int.tryParse(count);
      }
    }
    return null;
  }

  static int? recurrenceInterval(String? rule) {
    if (rule == null || rule.isEmpty) {
      return null;
    }

    final List<String> ruleParts = rule.split(';');
    for (String part in ruleParts) {
      if (part.startsWith('INTERVAL')) {
        final String interval = part.replaceFirst('INTERVAL=', '');
        return int.tryParse(interval);
      }
    }
    return null;
  }


  static String formatDate (DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  static String formatTime (DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(dateTime);
  }
}
