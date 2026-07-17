import 'team_availability.dart';

/// Aggregate team availability counters for UI / reports.
class TeamAvailabilitySummary {
  const TeamAvailabilitySummary({
    required this.items,
    required this.totalMembers,
    required this.availableCount,
    required this.unavailableCount,
    required this.conflictCount,
    required this.availabilityPercent,
  });

  factory TeamAvailabilitySummary.fromItems(List<TeamAvailability> items) {
    var availableCount = 0;
    var unavailableCount = 0;
    var conflictCount = 0;

    for (final item in items) {
      if (item.isAvailable) {
        availableCount++;
      } else {
        unavailableCount++;
      }
      conflictCount += item.conflicts.length;
    }

    final totalMembers = items.length;
    final availabilityPercent = totalMembers == 0
        ? 0.0
        : (availableCount * 100.0) / totalMembers;

    return TeamAvailabilitySummary(
      items: List<TeamAvailability>.unmodifiable(items),
      totalMembers: totalMembers,
      availableCount: availableCount,
      unavailableCount: unavailableCount,
      conflictCount: conflictCount,
      availabilityPercent: availabilityPercent,
    );
  }

  static const empty = TeamAvailabilitySummary(
    items: [],
    totalMembers: 0,
    availableCount: 0,
    unavailableCount: 0,
    conflictCount: 0,
    availabilityPercent: 0,
  );

  final List<TeamAvailability> items;
  final int totalMembers;
  final int availableCount;
  final int unavailableCount;
  final int conflictCount;

  /// `availableCount / totalMembers * 100` (0 when empty).
  final double availabilityPercent;
}
