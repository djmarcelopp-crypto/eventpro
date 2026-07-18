import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team_filters.dart';
import '../models/team_member_status.dart';

class TeamFiltersNotifier extends Notifier<TeamFilters> {
  @override
  TeamFilters build() => TeamFilters.empty;

  void setRoleId(String? roleId) {
    state = state.copyWith(
      roleId: roleId,
      clearRoleId: roleId == null,
    );
  }

  void setStatus(TeamMemberStatus? status) {
    state = state.copyWith(
      status: status,
      clearStatus: status == null,
    );
  }

  void setNameQuery(String query) {
    state = state.copyWith(nameQuery: query);
  }

  void clear() {
    state = TeamFilters.empty;
  }
}

final teamFiltersProvider =
    NotifierProvider<TeamFiltersNotifier, TeamFilters>(TeamFiltersNotifier.new);
