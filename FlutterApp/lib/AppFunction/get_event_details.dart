import 'package:syncfusion_flutter_calendar/calendar.dart';

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
}
