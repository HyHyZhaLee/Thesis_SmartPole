class DayOfWeekUtils {
  static String getDayOfWeek(DateTime date) {
    const List<String> daysOfWeek = [
      'SU',
      'MO',
      'TU',
      'WE',
      'TH',
      'FR',
      'SA',
    ];

    return daysOfWeek[date.weekday % 7];
  }
}
