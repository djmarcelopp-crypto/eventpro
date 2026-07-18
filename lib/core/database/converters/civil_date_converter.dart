abstract class CivilDateConverter {
  static String? toIsoDate(DateTime? date) {
    if (date == null) {
      return null;
    }

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  static DateTime? fromIsoDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) {
      return null;
    }

    final parts = isoDate.split('-');
    if (parts.length != 3) {
      return null;
    }

    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    return DateTime(year, month, day);
  }
}
