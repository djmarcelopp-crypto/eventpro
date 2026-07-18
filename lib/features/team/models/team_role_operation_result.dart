import 'team_role.dart';

/// Outcome of [TeamRoleService] create / update / delete / activation.
enum TeamRoleOperationStatus {
  success,
  validationFailed,
  duplicateName,
  notFound,
  deleted,
  blockedByUsage,
  failure,
}

/// Result of a [TeamRole] operation.
class TeamRoleOperationResult {
  const TeamRoleOperationResult._({
    required this.status,
    this.role,
    this.errors = const [],
    this.blockingMemberCount = 0,
  });

  factory TeamRoleOperationResult.success(TeamRole role) {
    return TeamRoleOperationResult._(
      status: TeamRoleOperationStatus.success,
      role: role,
    );
  }

  factory TeamRoleOperationResult.validationFailed(List<String> errors) {
    return TeamRoleOperationResult._(
      status: TeamRoleOperationStatus.validationFailed,
      errors: errors,
    );
  }

  factory TeamRoleOperationResult.duplicateName() {
    return const TeamRoleOperationResult._(
      status: TeamRoleOperationStatus.duplicateName,
    );
  }

  factory TeamRoleOperationResult.notFound() {
    return const TeamRoleOperationResult._(
      status: TeamRoleOperationStatus.notFound,
    );
  }

  factory TeamRoleOperationResult.deleted() {
    return const TeamRoleOperationResult._(
      status: TeamRoleOperationStatus.deleted,
    );
  }

  factory TeamRoleOperationResult.blockedByUsage({
    required int blockingMemberCount,
  }) {
    return TeamRoleOperationResult._(
      status: TeamRoleOperationStatus.blockedByUsage,
      blockingMemberCount: blockingMemberCount,
    );
  }

  factory TeamRoleOperationResult.failure() {
    return const TeamRoleOperationResult._(
      status: TeamRoleOperationStatus.failure,
    );
  }

  final TeamRoleOperationStatus status;
  final TeamRole? role;
  final List<String> errors;

  /// Number of [TeamMember] records still referencing this role.
  /// Meaningful when [status] is [TeamRoleOperationStatus.blockedByUsage].
  final int blockingMemberCount;

  bool get isSuccess => status == TeamRoleOperationStatus.success;
  bool get isDeleted => status == TeamRoleOperationStatus.deleted;
  bool get isBlockedByUsage =>
      status == TeamRoleOperationStatus.blockedByUsage;
}
