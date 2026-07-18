/// Outcome of `FinancialCategoryService.delete`.
enum FinancialCategoryDeleteStatus { deleted, notFound, blockedByUsage, failure }

class FinancialCategoryDeleteResult {
  const FinancialCategoryDeleteResult({
    required this.status,
    this.blockingEntryCount = 0,
  });

  final FinancialCategoryDeleteStatus status;

  /// Number of `FinancialEntry` records still referencing this category.
  /// Only meaningful when [status] is [FinancialCategoryDeleteStatus.blockedByUsage].
  final int blockingEntryCount;

  bool get isDeleted => status == FinancialCategoryDeleteStatus.deleted;
  bool get isBlockedByUsage =>
      status == FinancialCategoryDeleteStatus.blockedByUsage;
}
