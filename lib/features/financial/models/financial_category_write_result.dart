import 'financial_category.dart';

/// Outcome of `FinancialCategoryService.create`/`update`.
enum FinancialCategoryWriteStatus { success, validationFailed, notFound, failure }

/// Result of a write operation (create/update) on a [FinancialCategory].
/// Exactly one of [category] or [errors] is meaningful, depending on
/// [status].
class FinancialCategoryWriteResult {
  const FinancialCategoryWriteResult._({
    required this.status,
    this.category,
    this.errors = const [],
  });

  factory FinancialCategoryWriteResult.success(FinancialCategory category) {
    return FinancialCategoryWriteResult._(
      status: FinancialCategoryWriteStatus.success,
      category: category,
    );
  }

  factory FinancialCategoryWriteResult.validationFailed(List<String> errors) {
    return FinancialCategoryWriteResult._(
      status: FinancialCategoryWriteStatus.validationFailed,
      errors: errors,
    );
  }

  factory FinancialCategoryWriteResult.notFound() {
    return const FinancialCategoryWriteResult._(
      status: FinancialCategoryWriteStatus.notFound,
    );
  }

  factory FinancialCategoryWriteResult.failure() {
    return const FinancialCategoryWriteResult._(
      status: FinancialCategoryWriteStatus.failure,
    );
  }

  final FinancialCategoryWriteStatus status;
  final FinancialCategory? category;
  final List<String> errors;

  bool get isSuccess => status == FinancialCategoryWriteStatus.success;
}
