import 'team_member.dart';

/// Outcome of [TeamMemberService] create / update / delete.
enum TeamOperationStatus {
  success,
  validationFailed,
  roleNotFound,
  roleInactive,
  notFound,
  deleted,
  failure,
}

/// Result of a [TeamMember] operation.
class TeamOperationResult {
  const TeamOperationResult._({
    required this.status,
    this.member,
    this.errors = const [],
  });

  factory TeamOperationResult.success(TeamMember member) {
    return TeamOperationResult._(
      status: TeamOperationStatus.success,
      member: member,
    );
  }

  factory TeamOperationResult.validationFailed(List<String> errors) {
    return TeamOperationResult._(
      status: TeamOperationStatus.validationFailed,
      errors: errors,
    );
  }

  factory TeamOperationResult.roleNotFound() {
    return const TeamOperationResult._(
      status: TeamOperationStatus.roleNotFound,
    );
  }

  factory TeamOperationResult.roleInactive() {
    return const TeamOperationResult._(
      status: TeamOperationStatus.roleInactive,
    );
  }

  factory TeamOperationResult.notFound() {
    return const TeamOperationResult._(
      status: TeamOperationStatus.notFound,
    );
  }

  factory TeamOperationResult.deleted() {
    return const TeamOperationResult._(
      status: TeamOperationStatus.deleted,
    );
  }

  factory TeamOperationResult.failure() {
    return const TeamOperationResult._(
      status: TeamOperationStatus.failure,
    );
  }

  final TeamOperationStatus status;
  final TeamMember? member;
  final List<String> errors;

  bool get isSuccess => status == TeamOperationStatus.success;
  bool get isDeleted => status == TeamOperationStatus.deleted;
}
