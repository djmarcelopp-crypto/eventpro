/// Outcome of `QuoteTeamService.remove`.
enum QuoteTeamDeleteStatus { deleted, notFound, failure }

class QuoteTeamDeleteResult {
  const QuoteTeamDeleteResult({required this.status});

  final QuoteTeamDeleteStatus status;

  bool get isDeleted => status == QuoteTeamDeleteStatus.deleted;
}
