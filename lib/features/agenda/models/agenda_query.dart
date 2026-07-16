/// Shape of an [AgendaQuery] — determines how the queried civil-date range
/// was built, purely for caller/debugging context. `AgendaAvailabilityQueryService`
/// treats every kind identically once resolved into [AgendaQuery.days].
enum AgendaQueryKind { day, dateRange, week, month }

/// A structured request for `AgendaAvailabilityQueryService`, resolved into
/// an inclusive civil-date range (`rangeStart`..`rangeEnd`, no time
/// component). Carries no availability logic of its own — day-by-day
/// analysis is entirely delegated to `AgendaAvailabilityAnalyzer`.
class AgendaQuery {
  const AgendaQuery._({
    required this.kind,
    required this.rangeStart,
    required this.rangeEnd,
  });

  /// A single civil day.
  factory AgendaQuery.day(DateTime date) {
    final civil = _civilDate(date);
    return AgendaQuery._(
      kind: AgendaQueryKind.day,
      rangeStart: civil,
      rangeEnd: civil,
    );
  }

  /// An inclusive range between two civil days. Throws [ArgumentError] when
  /// [end] is before [start].
  factory AgendaQuery.dateRange({required DateTime start, required DateTime end}) {
    final civilStart = _civilDate(start);
    final civilEnd = _civilDate(end);
    if (civilEnd.isBefore(civilStart)) {
      throw ArgumentError('end must not be before start');
    }
    return AgendaQuery._(
      kind: AgendaQueryKind.dateRange,
      rangeStart: civilStart,
      rangeEnd: civilEnd,
    );
  }

  /// The ISO week (Monday–Sunday) containing [date].
  factory AgendaQuery.week(DateTime date) {
    final civil = _civilDate(date);
    final weekStart = civil.subtract(Duration(days: civil.weekday - DateTime.monday));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return AgendaQuery._(
      kind: AgendaQueryKind.week,
      rangeStart: weekStart,
      rangeEnd: weekEnd,
    );
  }

  /// The full calendar month containing [date].
  factory AgendaQuery.month(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(
      date.year,
      date.month + 1,
      1,
    ).subtract(const Duration(days: 1));
    return AgendaQuery._(
      kind: AgendaQueryKind.month,
      rangeStart: firstDay,
      rangeEnd: lastDay,
    );
  }

  final AgendaQueryKind kind;

  /// First civil day of the queried range (inclusive).
  final DateTime rangeStart;

  /// Last civil day of the queried range (inclusive).
  final DateTime rangeEnd;

  /// Every civil day between [rangeStart] and [rangeEnd], inclusive, in
  /// chronological order.
  List<DateTime> get days {
    final result = <DateTime>[];
    var cursor = rangeStart;
    while (!cursor.isAfter(rangeEnd)) {
      result.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }
    return result;
  }

  static DateTime _civilDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
