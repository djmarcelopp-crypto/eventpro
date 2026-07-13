abstract class QuoteTimeFormatter {
  static String format(TimeOfDayValue time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String? formatOptional(TimeOfDayValue? time) {
    if (time == null) {
      return null;
    }
    return format(time);
  }
}

class TimeOfDayValue {
  const TimeOfDayValue({
    required this.hour,
    required this.minute,
  });

  final int hour;
  final int minute;
}
