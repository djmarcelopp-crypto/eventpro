import '../models/team_member.dart';
import '../models/team_member_status.dart';

/// Presentation counters for Equipe list / Dashboard cards.
class TeamListSummary {
  const TeamListSummary({
    required this.activeCount,
    required this.unavailableCount,
    required this.inactiveCount,
    required this.totalMembers,
    required this.rolesCount,
  });

  static const empty = TeamListSummary(
    activeCount: 0,
    unavailableCount: 0,
    inactiveCount: 0,
    totalMembers: 0,
    rolesCount: 0,
  );

  factory TeamListSummary.fromMembers({
    required List<TeamMember> members,
    required int rolesCount,
  }) {
    var activeCount = 0;
    var unavailableCount = 0;
    var inactiveCount = 0;
    for (final member in members) {
      switch (member.status) {
        case TeamMemberStatus.active:
          activeCount++;
        case TeamMemberStatus.unavailable:
          unavailableCount++;
        case TeamMemberStatus.inactive:
          inactiveCount++;
      }
    }
    return TeamListSummary(
      activeCount: activeCount,
      unavailableCount: unavailableCount,
      inactiveCount: inactiveCount,
      totalMembers: members.length,
      rolesCount: rolesCount,
    );
  }

  final int activeCount;
  final int unavailableCount;
  final int inactiveCount;
  final int totalMembers;
  final int rolesCount;
}
