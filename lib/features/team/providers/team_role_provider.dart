import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/team_role_repository.dart';
import '../models/team_role.dart';
import '../models/team_role_operation_result.dart';
import '../utils/team_role_service.dart';
import 'team_role_repository_provider.dart';
import 'team_role_service_provider.dart';

class TeamRoleNotifier extends AsyncNotifier<List<TeamRole>> {
  TeamRoleRepository get _repository => ref.read(teamRoleRepositoryProvider);

  TeamRoleService get _service => ref.read(teamRoleServiceProvider);

  @override
  Future<List<TeamRole>> build() async {
    return _repository.listAll();
  }

  void hydrate(List<TeamRole> roles) {
    state = AsyncValue.data(List<TeamRole>.unmodifiable(roles));
  }

  TeamRole? findById(String id) {
    final current = state.value;
    if (current == null) {
      return null;
    }
    for (final role in current) {
      if (role.id == id) {
        return role;
      }
    }
    return null;
  }

  Future<TeamRoleOperationResult> addRole(TeamRole draft) async {
    final result = await _service.create(draft);
    if (result.isSuccess && result.role != null) {
      final current = state.value ?? const <TeamRole>[];
      final next = [...current, result.role!]
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      state = AsyncValue.data(List<TeamRole>.unmodifiable(next));
    }
    return result;
  }

  Future<TeamRoleOperationResult> updateRole(TeamRole role) async {
    final result = await _service.update(role);
    if (result.isSuccess && result.role != null) {
      final current = state.value ?? const <TeamRole>[];
      final next = [
        for (final item in current)
          if (item.id == result.role!.id) result.role! else item,
      ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      state = AsyncValue.data(List<TeamRole>.unmodifiable(next));
    }
    return result;
  }

  Future<TeamRoleOperationResult> activateRole(String id) async {
    final result = await _service.activate(id);
    if (result.isSuccess && result.role != null) {
      _replaceRole(result.role!);
    }
    return result;
  }

  Future<TeamRoleOperationResult> deactivateRole(String id) async {
    final result = await _service.deactivate(id);
    if (result.isSuccess && result.role != null) {
      _replaceRole(result.role!);
    }
    return result;
  }

  Future<TeamRoleOperationResult> deleteRole(String id) async {
    final result = await _service.delete(id);
    if (result.isDeleted) {
      final current = state.value ?? const <TeamRole>[];
      state = AsyncValue.data(
        List<TeamRole>.unmodifiable([
          for (final role in current)
            if (role.id != id) role,
        ]),
      );
    }
    return result;
  }

  void _replaceRole(TeamRole role) {
    final current = state.value ?? const <TeamRole>[];
    final next = [
      for (final item in current)
        if (item.id == role.id) role else item,
    ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    state = AsyncValue.data(List<TeamRole>.unmodifiable(next));
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.listAll);
  }
}

/// TeamRoleProvider — orchestrates [TeamRoleService] only.
final teamRoleProvider =
    AsyncNotifierProvider<TeamRoleNotifier, List<TeamRole>>(
      TeamRoleNotifier.new,
    );
