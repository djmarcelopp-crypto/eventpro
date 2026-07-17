import 'package:uuid/uuid.dart';

import '../data/repositories/team_member_repository.dart';
import '../data/repositories/team_role_repository.dart';
import '../models/team_role.dart';
import '../models/team_role_operation_result.dart';
import 'team_role_validator.dart';

/// Coordinates validation and persistence for [TeamRole] writes.
///
/// Repositories stay limited to reading/writing rows; every business rule
/// (required name, case-insensitive uniqueness, usage check on delete,
/// activation via update) lives here.
class TeamRoleService {
  TeamRoleService({
    required this._roleRepository,
    required this._memberRepository,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final TeamRoleRepository _roleRepository;
  final TeamMemberRepository _memberRepository;

  /// Injectable clock — defaults to [DateTime.now], overridable in tests.
  /// Never call [DateTime.now] directly anywhere else in this class.
  final DateTime Function() _clock;

  Future<TeamRoleOperationResult> create(TeamRole draft) async {
    final normalizedName = draft.name.trim();
    final fieldsResult = TeamRoleValidator.validateFields(name: normalizedName);
    if (!fieldsResult.isValid) {
      return TeamRoleOperationResult.validationFailed(fieldsResult.errors);
    }

    if (await _hasDuplicateName(normalizedName)) {
      return TeamRoleOperationResult.duplicateName();
    }

    final now = _clock();
    final role = draft.copyWith(
      id: _uuid.v7(),
      name: normalizedName,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _roleRepository.insert(role);
      return TeamRoleOperationResult.success(role);
    } catch (_) {
      return TeamRoleOperationResult.failure();
    }
  }

  Future<TeamRoleOperationResult> update(TeamRole role) async {
    final existing = await _roleRepository.findById(role.id);
    if (existing == null) {
      return TeamRoleOperationResult.notFound();
    }

    final normalizedName = role.name.trim();
    final fieldsResult = TeamRoleValidator.validateFields(name: normalizedName);
    if (!fieldsResult.isValid) {
      return TeamRoleOperationResult.validationFailed(fieldsResult.errors);
    }

    if (await _hasDuplicateName(normalizedName, excludingId: existing.id)) {
      return TeamRoleOperationResult.duplicateName();
    }

    final now = _clock();
    final updated = role.copyWith(
      id: existing.id,
      name: normalizedName,
      createdAt: existing.createdAt,
      updatedAt: now,
    );

    try {
      await _roleRepository.update(updated);
      return TeamRoleOperationResult.success(updated);
    } catch (_) {
      return TeamRoleOperationResult.failure();
    }
  }

  /// Activates a role (`active: true`) preserving [TeamRole.createdAt].
  Future<TeamRoleOperationResult> activate(String id) async {
    return _setActive(id, active: true);
  }

  /// Deactivates a role (`active: false`) preserving [TeamRole.createdAt].
  Future<TeamRoleOperationResult> deactivate(String id) async {
    return _setActive(id, active: false);
  }

  Future<TeamRoleOperationResult> delete(String id) async {
    final existing = await _roleRepository.findById(id);
    if (existing == null) {
      return TeamRoleOperationResult.notFound();
    }

    final members = await _memberRepository.listAll();
    final usageCount = members.where((member) => member.roleId == id).length;
    if (usageCount > 0) {
      return TeamRoleOperationResult.blockedByUsage(
        blockingMemberCount: usageCount,
      );
    }

    try {
      await _roleRepository.delete(id);
      return TeamRoleOperationResult.deleted();
    } catch (_) {
      return TeamRoleOperationResult.failure();
    }
  }

  Future<TeamRoleOperationResult> _setActive(
    String id, {
    required bool active,
  }) async {
    final existing = await _roleRepository.findById(id);
    if (existing == null) {
      return TeamRoleOperationResult.notFound();
    }

    return update(existing.copyWith(active: active));
  }

  Future<bool> _hasDuplicateName(
    String name, {
    String? excludingId,
  }) async {
    final normalized = name.trim().toLowerCase();
    final roles = await _roleRepository.listAll();
    return roles.any(
      (role) =>
          role.id != excludingId &&
          role.name.trim().toLowerCase() == normalized,
    );
  }
}
