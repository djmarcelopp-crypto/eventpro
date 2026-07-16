import '../models/agenda_occupancy.dart';

/// Pure conflict detector — no Riverpod, no persistence. Only compares two
/// intervals (or two [AgendaOccupancy] entries) using the standard
/// half-open overlap rule: two intervals overlap when each one starts
/// before the other one ends.
abstract class AgendaOverlapChecker {
  static bool overlaps({
    required DateTime firstStart,
    required DateTime firstEnd,
    required DateTime secondStart,
    required DateTime secondEnd,
  }) {
    return firstStart.isBefore(secondEnd) && secondStart.isBefore(firstEnd);
  }

  static bool occupanciesOverlap(
    AgendaOccupancy first,
    AgendaOccupancy second,
  ) {
    return overlaps(
      firstStart: first.start,
      firstEnd: first.end,
      secondStart: second.start,
      secondEnd: second.end,
    );
  }
}
