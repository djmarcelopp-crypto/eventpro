import 'agenda_availability_result.dart';

/// A single day's outcome within an [AgendaQueryResult], wrapping the
/// underlying `AgendaAvailabilityAnalyzer` output for that civil day —
/// no availability logic is re-implemented here.
class AgendaDailyAvailability {
  const AgendaDailyAvailability({required this.date, required this.result});

  /// Civil date (no time component) this entry refers to.
  final DateTime date;

  final AgendaAvailabilityResult result;

  AgendaAvailabilityStatus get status => result.status;
}

/// Count of days per [AgendaAvailabilityStatus] within an [AgendaQueryResult].
class AgendaAvailabilitySummary {
  const AgendaAvailabilitySummary({
    required this.freeDays,
    required this.partialDays,
    required this.busyDays,
  });

  final int freeDays;
  final int partialDays;
  final int busyDays;

  int get totalDays => freeDays + partialDays + busyDays;
}

/// Structured output of `AgendaAvailabilityQueryService.run`.
class AgendaQueryResult {
  const AgendaQueryResult({
    required this.periodStart,
    required this.periodEnd,
    required this.availability,
    required this.dailyResults,
    required this.conflicts,
    required this.summary,
  });

  /// Start of the queried period (civil date, `00:00`).
  final DateTime periodStart;

  /// Exclusive end of the queried period — midnight of the day right after
  /// the last queried civil day, consistent with the half-open convention
  /// used across the Agenda.
  final DateTime periodEnd;

  /// Aggregate status across every day in [dailyResults]: `free` when every
  /// day is free, `busy` when every day is busy, `partial` otherwise.
  final AgendaAvailabilityStatus availability;

  /// One entry per civil day in the queried period, in chronological order.
  final List<AgendaDailyAvailability> dailyResults;

  /// Occupancy conflicts found across every day, deduplicated by occupancy
  /// pair (the same pair of overlapping occupancies is only reported once,
  /// even if their interval spans several queried days).
  final List<AgendaOccupancyConflict> conflicts;

  final AgendaAvailabilitySummary summary;
}
