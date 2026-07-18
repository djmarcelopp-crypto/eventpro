import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';

class ResolvedAgendaInterval {
  const ResolvedAgendaInterval({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

/// Converts a [QuoteEventSnapshot] (civil date + optional "HH:mm" strings)
/// into a concrete local [DateTime] interval, without any timezone
/// conversion (the civil date and local wall-clock time are preserved as-is).
abstract class AgendaEventIntervalResolver {
  static const fallbackStartHour = 0;
  static const fallbackStartMinute = 0;
  static const fallbackEndHour = 23;
  static const fallbackEndMinute = 59;

  /// Returns `null` when the snapshot has no date — an event without a date
  /// does not occupy the agenda.
  static ResolvedAgendaInterval? resolve(QuoteEventSnapshot snapshot) {
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

    return ResolvedAgendaInterval(start: start, end: end);
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
