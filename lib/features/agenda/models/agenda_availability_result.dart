import 'agenda_occupancy.dart';

/// Availability classification for a queried period. `partial` is only
/// possible for ranged queries — see `AgendaAvailabilityAnalyzer`.
enum AgendaAvailabilityStatus { free, partial, busy }

/// A contiguous free sub-interval within the queried period, not covered by
/// any [AgendaOccupancy].
class AgendaFreeInterval {
  const AgendaFreeInterval({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

/// Two [AgendaOccupancy] entries whose intervals overlap each other
/// (half-open rule — see `AgendaOverlapChecker`), regardless of whether they
/// overlap the queried period fully or only partially.
class AgendaOccupancyConflict {
  const AgendaOccupancyConflict({required this.first, required this.second});

  final AgendaOccupancy first;
  final AgendaOccupancy second;
}

/// Structured output of `AgendaAvailabilityAnalyzer.analyze`.
class AgendaAvailabilityResult {
  const AgendaAvailabilityResult({
    required this.status,
    required this.reason,
    required this.occupancies,
    required this.freeIntervals,
    required this.conflicts,
  });

  final AgendaAvailabilityStatus status;

  /// Technical, non-localized explanation of [status]. Not meant to be
  /// presented as-is in the UI.
  final String reason;

  /// Occupancies that overlap the queried period, ordered by `start`.
  /// Occupancies outside the queried period are not included.
  final List<AgendaOccupancy> occupancies;

  /// Gaps within the queried period not covered by any occupancy, ordered
  /// by `start`. Empty when [status] is `busy`; equal to the whole queried
  /// period when [status] is `free`.
  final List<AgendaFreeInterval> freeIntervals;

  /// Pairs of [occupancies] that overlap each other.
  final List<AgendaOccupancyConflict> conflicts;
}
