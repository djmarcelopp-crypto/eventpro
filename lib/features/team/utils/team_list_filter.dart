import '../models/team_filters.dart';
import '../models/team_member.dart';

/// Applies presentation filters to a team member list.
abstract class TeamListFilter {
  static List<TeamMember> apply(
    List<TeamMember> members,
    TeamFilters filters,
  ) {
    final query = filters.nameQuery.trim().toLowerCase();
    return [
      for (final member in members)
        if (_matches(member, filters, query)) member,
    ];
  }

  static bool _matches(
    TeamMember member,
    TeamFilters filters,
    String query,
  ) {
    if (filters.roleId != null && member.roleId != filters.roleId) {
      return false;
    }
    if (filters.status != null && member.status != filters.status) {
      return false;
    }
    if (query.isNotEmpty && !member.name.toLowerCase().contains(query)) {
      return false;
    }
    return true;
  }
}
