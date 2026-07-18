import '../models/agenda_availability_result.dart';
import '../models/agenda_occupancy.dart';
import 'agenda_overlap_checker.dart';

/// Pure availability engine for the Agenda. Works exclusively with
/// [AgendaOccupancy] — no knowledge of `Quote`, `AgendaBlock`, Riverpod or
/// any persistence layer. Combining quotes and manual blocks into
/// [AgendaOccupancy] is the caller's responsibility (`agendaOccupancyProvider`).
abstract class AgendaAvailabilityAnalyzer {
  /// Analyzes [occupancies] against the queried period.
  ///
  /// [date] anchors the default whole-day query (`00:00` to the next day's
  /// `00:00`, local wall-clock time, no timezone conversion) when
  /// [periodStart]/[periodEnd] are omitted.
  ///
  /// [periodStart] and [periodEnd] narrow the query to a specific interval
  /// (which may itself cross midnight). Both must be provided together, or
  /// both omitted — providing only one throws [ArgumentError].
  static AgendaAvailabilityResult analyze({
    required DateTime date,
    required List<AgendaOccupancy> occupancies,
    DateTime? periodStart,
    DateTime? periodEnd,
  }) {
    final period = _resolvePeriod(date, periodStart, periodEnd);

    final relevant = occupancies
        .where(
          (occupancy) => AgendaOverlapChecker.overlaps(
            firstStart: occupancy.start,
            firstEnd: occupancy.end,
            secondStart: period.start,
            secondEnd: period.end,
          ),
        )
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    final busyIntervals = _mergeBusyIntervals(relevant, period);
    final freeIntervals = _computeFreeIntervals(busyIntervals, period);
    final conflicts = _findConflicts(relevant);

    if (relevant.isEmpty) {
      return AgendaAvailabilityResult(
        status: AgendaAvailabilityStatus.free,
        reason: 'No occupancies overlap the queried period.',
        occupancies: relevant,
        freeIntervals: freeIntervals,
        conflicts: conflicts,
      );
    }

    if (freeIntervals.isEmpty) {
      return AgendaAvailabilityResult(
        status: AgendaAvailabilityStatus.busy,
        reason:
            '${relevant.length} occupancy(ies) fully cover the queried period.',
        occupancies: relevant,
        freeIntervals: freeIntervals,
        conflicts: conflicts,
      );
    }

    return AgendaAvailabilityResult(
      status: AgendaAvailabilityStatus.partial,
      reason:
          '${relevant.length} occupancy(ies) partially cover the queried '
          'period, leaving ${freeIntervals.length} free interval(s).',
      occupancies: relevant,
      freeIntervals: freeIntervals,
      conflicts: conflicts,
    );
  }

  static ({DateTime start, DateTime end}) _resolvePeriod(
    DateTime date,
    DateTime? periodStart,
    DateTime? periodEnd,
  ) {
    if (periodStart == null && periodEnd == null) {
      final dayStart = DateTime(date.year, date.month, date.day);
      return (start: dayStart, end: dayStart.add(const Duration(days: 1)));
    }

    if (periodStart == null || periodEnd == null) {
      throw ArgumentError(
        'periodStart and periodEnd must both be provided or both omitted',
      );
    }

    if (!periodEnd.isAfter(periodStart)) {
      throw ArgumentError('periodEnd must be after periodStart');
    }

    return (start: periodStart, end: periodEnd);
  }

  /// Merges overlapping/adjacent occupancy intervals (clipped to [period])
  /// into the minimal set of covered ranges. Intervals that only touch at
  /// the boundary (one ends exactly when the other starts) are merged
  /// together, so no artificial zero-length free gap is reported between
  /// them ("bordas de horário sem falso conflito").
  static List<AgendaFreeInterval> _mergeBusyIntervals(
    List<AgendaOccupancy> sortedRelevant,
    ({DateTime start, DateTime end}) period,
  ) {
    final merged = <AgendaFreeInterval>[];

    for (final occupancy in sortedRelevant) {
      final clippedStart = occupancy.start.isBefore(period.start)
          ? period.start
          : occupancy.start;
      final clippedEnd = occupancy.end.isAfter(period.end)
          ? period.end
          : occupancy.end;

      if (merged.isNotEmpty && !clippedStart.isAfter(merged.last.end)) {
        final last = merged.removeLast();
        final extendedEnd = clippedEnd.isAfter(last.end)
            ? clippedEnd
            : last.end;
        merged.add(AgendaFreeInterval(start: last.start, end: extendedEnd));
      } else {
        merged.add(AgendaFreeInterval(start: clippedStart, end: clippedEnd));
      }
    }

    return merged;
  }

  static List<AgendaFreeInterval> _computeFreeIntervals(
    List<AgendaFreeInterval> busyIntervals,
    ({DateTime start, DateTime end}) period,
  ) {
    final free = <AgendaFreeInterval>[];
    var cursor = period.start;

    for (final busy in busyIntervals) {
      if (busy.start.isAfter(cursor)) {
        free.add(AgendaFreeInterval(start: cursor, end: busy.start));
      }
      if (busy.end.isAfter(cursor)) {
        cursor = busy.end;
      }
    }

    if (cursor.isBefore(period.end)) {
      free.add(AgendaFreeInterval(start: cursor, end: period.end));
    }

    return free;
  }

  static List<AgendaOccupancyConflict> _findConflicts(
    List<AgendaOccupancy> sortedRelevant,
  ) {
    final conflicts = <AgendaOccupancyConflict>[];

    for (var i = 0; i < sortedRelevant.length; i++) {
      for (var j = i + 1; j < sortedRelevant.length; j++) {
        if (AgendaOverlapChecker.occupanciesOverlap(
          sortedRelevant[i],
          sortedRelevant[j],
        )) {
          conflicts.add(
            AgendaOccupancyConflict(
              first: sortedRelevant[i],
              second: sortedRelevant[j],
            ),
          );
        }
      }
    }

    return conflicts;
  }
}
