import 'package:uuid/uuid.dart';

import '../data/repositories/team_member_repository.dart';
import '../data/repositories/team_role_repository.dart';
import '../models/team_member.dart';
import '../models/team_operation_result.dart';
import 'team_member_validator.dart';

/// Coordinates validation and persistence for [TeamMember] writes.
///
/// Repositories stay limited to reading/writing rows; every business rule
/// (field validation, role existence/activeness, timestamps) lives here.
class TeamMemberService {
  TeamMemberService({
    required this._memberRepository,
    required this._roleRepository,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final TeamMemberRepository _memberRepository;
  final TeamRoleRepository _roleRepository;

  /// Injectable clock — defaults to [DateTime.now], overridable in tests.
  /// Never call [DateTime.now] directly anywhere else in this class.
  final DateTime Function() _clock;

  Future<TeamOperationResult> create(TeamMember draft) async {
    final fieldsResult = TeamMemberValidator.validate(draft);
    if (!fieldsResult.isValid) {
      return TeamOperationResult.validationFailed(fieldsResult.errors);
    }

    final roleError = await _checkRole(draft.roleId);
    if (roleError != null) {
      return roleError;
    }

    final now = _clock();
    final member = draft.copyWith(
      id: _uuid.v7(),
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _memberRepository.insert(member);
      return TeamOperationResult.success(member);
    } catch (_) {
      return TeamOperationResult.failure();
    }
  }

  Future<TeamOperationResult> update(TeamMember member) async {
    final existing = await _memberRepository.findById(member.id);
    if (existing == null) {
      return TeamOperationResult.notFound();
    }

    final fieldsResult = TeamMemberValidator.validate(member);
    if (!fieldsResult.isValid) {
      return TeamOperationResult.validationFailed(fieldsResult.errors);
    }

    final roleError = await _checkRole(member.roleId);
    if (roleError != null) {
      return roleError;
    }

    final now = _clock();
    final normalized = member.copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
      updatedAt: now,
    );

    try {
      await _memberRepository.update(normalized);
      return TeamOperationResult.success(normalized);
    } catch (_) {
      return TeamOperationResult.failure();
    }
  }

  Future<TeamOperationResult> delete(String id) async {
    final existing = await _memberRepository.findById(id);
    if (existing == null) {
      return TeamOperationResult.notFound();
    }

    try {
      await _memberRepository.delete(id);
      return TeamOperationResult.deleted();
    } catch (_) {
      return TeamOperationResult.failure();
    }
  }

  Future<TeamOperationResult?> _checkRole(String roleId) async {
    final role = await _roleRepository.findById(roleId);
    if (role == null) {
      return TeamOperationResult.roleNotFound();
    }
    if (!role.active) {
      return TeamOperationResult.roleInactive();
    }
    return null;
  }
}
