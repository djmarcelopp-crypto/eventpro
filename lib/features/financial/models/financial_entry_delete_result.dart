/// Outcome of `FinancialEntryService.delete`.
enum FinancialEntryDeleteStatus { deleted, notFound, failure }

class FinancialEntryDeleteResult {
  const FinancialEntryDeleteResult({required this.status});

  final FinancialEntryDeleteStatus status;

  bool get isDeleted => status == FinancialEntryDeleteStatus.deleted;
}
