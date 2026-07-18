import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/team_member_repository.dart';
import '../models/team_member.dart';
import '../models/team_operation_result.dart';
import '../utils/team_member_service.dart';
import 'team_member_repository_provider.dart';
import 'team_member_service_provider.dart';

class TeamMemberNotifier extends AsyncNotifier<List<TeamMember>> {
  TeamMemberRepository get _repository =>
      ref.read(teamMemberRepositoryProvider);

  TeamMemberService get _service => ref.read(teamMemberServiceProvider);

  @override
  Future<List<TeamMember>> build() async {
    return _repository.listAll();
  }

  void hydrate(List<TeamMember> members) {
    state = AsyncValue.data(List<TeamMember>.unmodifiable(members));
  }

  TeamMember? findById(String id) {
    final current = state.value;
    if (current == null) {
      return null;
    }
    for (final member in current) {
      if (member.id == id) {
        return member;
      }
    }
    return null;
  }

  Future<TeamOperationResult> addMember(TeamMember draft) async {
    final result = await _service.create(draft);
    if (result.isSuccess && result.member != null) {
      final current = state.value ?? const <TeamMember>[];
      final next = [...current, result.member!]
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      state = AsyncValue.data(List<TeamMember>.unmodifiable(next));
    }
    return result;
  }

  Future<TeamOperationResult> updateMember(TeamMember member) async {
    final result = await _service.update(member);
    if (result.isSuccess && result.member != null) {
      final current = state.value ?? const <TeamMember>[];
      final next = [
        for (final item in current)
          if (item.id == result.member!.id) result.member! else item,
      ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      state = AsyncValue.data(List<TeamMember>.unmodifiable(next));
    }
    return result;
  }

  Future<TeamOperationResult> deleteMember(String id) async {
    final result = await _service.delete(id);
    if (result.isDeleted) {
      final current = state.value ?? const <TeamMember>[];
      state = AsyncValue.data(
        List<TeamMember>.unmodifiable([
          for (final member in current)
            if (member.id != id) member,
        ]),
      );
    }
    return result;
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.listAll);
  }
}

/// TeamMemberProvider — orchestrates [TeamMemberService] only.
final teamMemberProvider =
    AsyncNotifierProvider<TeamMemberNotifier, List<TeamMember>>(
      TeamMemberNotifier.new,
    );
