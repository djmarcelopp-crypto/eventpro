abstract class TimestampConverter {
  static int toUtcMillis(DateTime dateTime) {
    return dateTime.toUtc().millisecondsSinceEpoch;
  }

  static DateTime fromUtcMillis(int millis) {
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true).toLocal();
  }
}
