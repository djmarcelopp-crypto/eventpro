import '../models/agenda_availability_result.dart';
import '../models/agenda_occupancy.dart';
import '../models/agenda_query.dart';
import '../models/agenda_query_result.dart';
import 'agenda_availability_analyzer.dart';

/// Organizes structured, multi-day availability queries (day / date range /
/// week / month) on top of [AgendaAvailabilityAnalyzer]. This service holds
/// no availability rules of its own — every day is analyzed by calling
/// [AgendaAvailabilityAnalyzer.analyze] once per civil day in [AgendaQuery.days]
/// and the results are only organized and aggregated here.
///
/// No Flutter, Riverpod, SQLite, DAO, Repository or UI dependency — pure
/// Dart, same as [AgendaAvailabilityAnalyzer].
abstract class AgendaAvailabilityQueryService {
  static AgendaQueryResult run({
    required AgendaQuery query,
    required List<AgendaOccupancy> occupancies,
  }) {
    final dailyResults = query.days
        .map(
          (day) => AgendaDailyAvailability(
            date: day,
            result: AgendaAvailabilityAnalyzer.analyze(
              date: day,
              occupancies: occupancies,
            ),
          ),
        )
        .toList();

    final summary = _summarize(dailyResults);

    return AgendaQueryResult(
      periodStart: query.rangeStart,
      periodEnd: query.rangeEnd.add(const Duration(days: 1)),
      availability: _overallAvailability(summary),
      dailyResults: dailyResults,
      conflicts: _aggregateConflicts(dailyResults),
      summary: summary,
    );
  }

  static AgendaAvailabilitySummary _summarize(
    List<AgendaDailyAvailability> dailyResults,
  ) {
    var free = 0;
    var partial = 0;
    var busy = 0;

    for (final daily in dailyResults) {
      switch (daily.status) {
        case AgendaAvailabilityStatus.free:
          free++;
        case AgendaAvailabilityStatus.partial:
          partial++;
        case AgendaAvailabilityStatus.busy:
          busy++;
      }
    }

    return AgendaAvailabilitySummary(
      freeDays: free,
      partialDays: partial,
      busyDays: busy,
    );
  }

  static AgendaAvailabilityStatus _overallAvailability(
    AgendaAvailabilitySummary summary,
  ) {
    if (summary.totalDays == 0 || summary.freeDays == summary.totalDays) {
      return AgendaAvailabilityStatus.free;
    }
    if (summary.busyDays == summary.totalDays) {
      return AgendaAvailabilityStatus.busy;
    }
    return AgendaAvailabilityStatus.partial;
  }

  static List<AgendaOccupancyConflict> _aggregateConflicts(
    List<AgendaDailyAvailability> dailyResults,
  ) {
    final seenPairs = <String>{};
    final aggregated = <AgendaOccupancyConflict>[];

    for (final daily in dailyResults) {
      for (final conflict in daily.result.conflicts) {
        final pairKey = _conflictPairKey(conflict);
        if (seenPairs.add(pairKey)) {
          aggregated.add(conflict);
        }
      }
    }

    return aggregated;
  }

  static String _conflictPairKey(AgendaOccupancyConflict conflict) {
    final ids = [conflict.first.id, conflict.second.id]..sort();
    return ids.join('::');
  }
}
