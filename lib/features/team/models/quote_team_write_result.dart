import 'quote_team_member.dart';

/// Outcome of `QuoteTeamService.add` (and future write ops).
enum QuoteTeamWriteStatus {
  success,
  validationFailed,
  quoteNotFound,
  memberNotFound,
  memberInactive,
  roleNotFound,
  roleInactive,
  duplicateMember,
  notFound,
  failure,
}

/// Result of a write operation on a [QuoteTeamMember] link.
class QuoteTeamWriteResult {
  const QuoteTeamWriteResult._({
    required this.status,
    this.item,
    this.errors = const [],
  });

  factory QuoteTeamWriteResult.success(QuoteTeamMember item) {
    return QuoteTeamWriteResult._(
      status: QuoteTeamWriteStatus.success,
      item: item,
    );
  }

  factory QuoteTeamWriteResult.validationFailed(List<String> errors) {
    return QuoteTeamWriteResult._(
      status: QuoteTeamWriteStatus.validationFailed,
      errors: errors,
    );
  }

  factory QuoteTeamWriteResult.quoteNotFound() {
    return const QuoteTeamWriteResult._(
      status: QuoteTeamWriteStatus.quoteNotFound,
    );
  }

  factory QuoteTeamWriteResult.memberNotFound() {
    return const QuoteTeamWriteResult._(
      status: QuoteTeamWriteStatus.memberNotFound,
    );
  }

  factory QuoteTeamWriteResult.memberInactive() {
    return const QuoteTeamWriteResult._(
      status: QuoteTeamWriteStatus.memberInactive,
    );
  }

  factory QuoteTeamWriteResult.roleNotFound() {
    return const QuoteTeamWriteResult._(
      status: QuoteTeamWriteStatus.roleNotFound,
    );
  }

  factory QuoteTeamWriteResult.roleInactive() {
    return const QuoteTeamWriteResult._(
      status: QuoteTeamWriteStatus.roleInactive,
    );
  }

  factory QuoteTeamWriteResult.duplicateMember() {
    return const QuoteTeamWriteResult._(
      status: QuoteTeamWriteStatus.duplicateMember,
    );
  }

  factory QuoteTeamWriteResult.notFound() {
    return const QuoteTeamWriteResult._(
      status: QuoteTeamWriteStatus.notFound,
    );
  }

  factory QuoteTeamWriteResult.failure() {
    return const QuoteTeamWriteResult._(
      status: QuoteTeamWriteStatus.failure,
    );
  }

  final QuoteTeamWriteStatus status;
  final QuoteTeamMember? item;
  final List<String> errors;

  bool get isSuccess => status == QuoteTeamWriteStatus.success;
}
