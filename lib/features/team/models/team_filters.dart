import '../models/team_member_status.dart';

/// Presentation filters for the team list (UI only).
class TeamFilters {
  const TeamFilters({
    this.roleId,
    this.status,
    this.nameQuery = '',
  });

  static const empty = TeamFilters();

  final String? roleId;
  final TeamMemberStatus? status;
  final String nameQuery;

  bool get hasActiveFilters =>
      roleId != null || status != null || nameQuery.trim().isNotEmpty;

  TeamFilters copyWith({
    String? roleId,
    TeamMemberStatus? status,
    String? nameQuery,
    bool clearRoleId = false,
    bool clearStatus = false,
  }) {
    return TeamFilters(
      roleId: clearRoleId ? null : (roleId ?? this.roleId),
      status: clearStatus ? null : (status ?? this.status),
      nameQuery: nameQuery ?? this.nameQuery,
    );
  }
}
