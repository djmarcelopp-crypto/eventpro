import '../../quotes/models/quote_event_snapshot.dart';
import '../models/equipment_event_period.dart';

/// Resolves a quote event snapshot into a concrete local period for stock
/// overlap checks.
///
/// Rules match civil-date agenda conversion (optional `HH:mm`, overnight wrap)
/// but this class does **not** depend on the Agenda feature.
abstract class EquipmentEventPeriodResolver {
  static const fallbackStartHour = 0;
  static const fallbackStartMinute = 0;
  static const fallbackEndHour = 23;
  static const fallbackEndMinute = 59;

  /// Returns `null` when the snapshot has no date — the quote does not
  /// consume equipment availability.
  static EquipmentEventPeriod? resolve(QuoteEventSnapshot snapshot) {
    final date = snapshot.date;
    if (date == null) {
      return null;
    }

    final start = _applyTime(
      date,
      snapshot.startTime,
      fallbackHour: fallbackStartHour,
      fallbackMinute: fallbackStartMinute,
    );
    var end = _applyTime(
      date,
      snapshot.endTime,
      fallbackHour: fallbackEndHour,
      fallbackMinute: fallbackEndMinute,
    );

    if (!end.isAfter(start)) {
      end = end.add(const Duration(days: 1));
    }

    return EquipmentEventPeriod(start: start, end: end);
  }

  static DateTime _applyTime(
    DateTime civilDate,
    String? time, {
    required int fallbackHour,
    required int fallbackMinute,
  }) {
    final parsed = _parseTime(time);
    return DateTime(
      civilDate.year,
      civilDate.month,
      civilDate.day,
      parsed?.hour ?? fallbackHour,
      parsed?.minute ?? fallbackMinute,
    );
  }

  static ({int hour, int minute})? _parseTime(String? value) {
    if (value == null) {
      return null;
    }
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(value.trim());
    if (match == null) {
      return null;
    }

    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      return null;
    }

    return (hour: hour, minute: minute);
  }
}
