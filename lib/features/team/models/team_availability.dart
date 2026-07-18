import 'team_consuming_quote.dart';
import 'team_schedule_conflict.dart';

/// Availability derived from quote links — independent of [TeamMemberStatus].
enum TeamAvailabilityStatus {
  /// No consuming quote demand for the evaluated scope.
  available,

  /// At least one consuming quote occupies the member in the evaluated scope.
  unavailable,
}

/// Dynamic availability snapshot for one [TeamMember].
///
/// Computed in memory from quote team links and event periods — never stored.
class TeamAvailability {
  const TeamAvailability({
    required this.teamMemberId,
    required this.status,
    required this.consumingQuotes,
    required this.conflicts,
  });

  final String teamMemberId;
  final TeamAvailabilityStatus status;
  final List<TeamConsumingQuote> consumingQuotes;
  final List<TeamScheduleConflict> conflicts;

  bool get hasConflicts => conflicts.isNotEmpty;
  bool get isAvailable => status == TeamAvailabilityStatus.available;
  bool get isUnavailable => status == TeamAvailabilityStatus.unavailable;
}
