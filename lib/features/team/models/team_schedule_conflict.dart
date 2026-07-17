import 'team_event_period.dart';

/// Schedule conflict when a member is linked to overlapping quote periods.
///
/// Pure domain value — never persisted.
class TeamScheduleConflict {
  const TeamScheduleConflict({
    required this.teamMemberId,
    required this.quoteId,
    required this.eventPeriod,
    required this.reason,
  });

  final String teamMemberId;
  final String quoteId;
  final TeamEventPeriod eventPeriod;

  /// Human-readable conflict reason (partial vs total overlap).
  final String reason;
}
