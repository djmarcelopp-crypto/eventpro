import 'financial_entry.dart';

/// Outcome of `FinancialEntryService.create`/`update`.
enum FinancialEntryWriteStatus {
  success,
  validationFailed,
  categoryNotFound,
  categoryInactive,
  categoryKindMismatch,
  notFound,
  failure,
}

/// Result of a write operation (create/update) on a [FinancialEntry].
/// Exactly one of [entry] or [errors] is meaningful, depending on [status].
class FinancialEntryWriteResult {
  const FinancialEntryWriteResult._({
    required this.status,
    this.entry,
    this.errors = const [],
  });

  factory FinancialEntryWriteResult.success(FinancialEntry entry) {
    return FinancialEntryWriteResult._(
      status: FinancialEntryWriteStatus.success,
      entry: entry,
    );
  }

  factory FinancialEntryWriteResult.validationFailed(List<String> errors) {
    return FinancialEntryWriteResult._(
      status: FinancialEntryWriteStatus.validationFailed,
      errors: errors,
    );
  }

  factory FinancialEntryWriteResult.categoryNotFound() {
    return const FinancialEntryWriteResult._(
      status: FinancialEntryWriteStatus.categoryNotFound,
    );
  }

  factory FinancialEntryWriteResult.categoryInactive() {
    return const FinancialEntryWriteResult._(
      status: FinancialEntryWriteStatus.categoryInactive,
    );
  }

  factory FinancialEntryWriteResult.categoryKindMismatch() {
    return const FinancialEntryWriteResult._(
      status: FinancialEntryWriteStatus.categoryKindMismatch,
    );
  }

  factory FinancialEntryWriteResult.notFound() {
    return const FinancialEntryWriteResult._(
      status: FinancialEntryWriteStatus.notFound,
    );
  }

  factory FinancialEntryWriteResult.failure() {
    return const FinancialEntryWriteResult._(
      status: FinancialEntryWriteStatus.failure,
    );
  }

  final FinancialEntryWriteStatus status;
  final FinancialEntry? entry;
  final List<String> errors;

  bool get isSuccess => status == FinancialEntryWriteStatus.success;
}
