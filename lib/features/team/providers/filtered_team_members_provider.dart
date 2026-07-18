import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team_member.dart';
import '../utils/team_list_filter.dart';
import 'team_filters_provider.dart';
import 'team_member_provider.dart';

final filteredTeamMembersProvider =
    Provider<AsyncValue<List<TeamMember>>>((ref) {
  final membersAsync = ref.watch(teamMemberProvider);
  final filters = ref.watch(teamFiltersProvider);
  return membersAsync.whenData(
    (members) => TeamListFilter.apply(members, filters),
  );
});
