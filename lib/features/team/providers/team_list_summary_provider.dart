import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/team_list_summary.dart';
import 'team_member_provider.dart';
import 'team_role_provider.dart';

/// Dashboard / list KPIs from the full roster (not filtered).
final teamListSummaryProvider = Provider<AsyncValue<TeamListSummary>>((ref) {
  final membersAsync = ref.watch(teamMemberProvider);
  final rolesAsync = ref.watch(teamRoleProvider);
  if (membersAsync.hasError) {
    return AsyncValue.error(
      membersAsync.error!,
      membersAsync.stackTrace ?? StackTrace.empty,
    );
  }
  if (rolesAsync.hasError) {
    return AsyncValue.error(
      rolesAsync.error!,
      rolesAsync.stackTrace ?? StackTrace.empty,
    );
  }
  if (!membersAsync.hasValue || !rolesAsync.hasValue) {
    return const AsyncValue.loading();
  }
  return AsyncValue.data(
    TeamListSummary.fromMembers(
      members: membersAsync.value!,
      rolesCount: rolesAsync.value!.length,
    ),
  );
});
