import 'package:uuid/uuid.dart';

import '../data/repositories/financial_category_repository.dart';
import '../data/repositories/financial_entry_repository.dart';
import '../models/financial_category.dart';
import '../models/financial_category_delete_result.dart';
import '../models/financial_category_write_result.dart';
import 'financial_category_validator.dart';

/// Coordinates validation and persistence for [FinancialCategory] writes.
///
/// Repositories stay limited to reading/writing rows; every business rule
/// (field validation, "category in use" check on delete) lives here, never
/// in `FinancialCategoryRepository`/`DriftFinancialCategoryRepository`.
class FinancialCategoryService {
  FinancialCategoryService({
    required FinancialCategoryRepository categoryRepository,
    required FinancialEntryRepository entryRepository,
    DateTime Function()? clock,
  }) : _categoryRepository = categoryRepository,
       _entryRepository = entryRepository,
       _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final FinancialCategoryRepository _categoryRepository;
  final FinancialEntryRepository _entryRepository;

  /// Injectable clock — defaults to [DateTime.now], overridable in tests.
  /// Never call [DateTime.now] directly anywhere else in this class.
  final DateTime Function() _clock;

  Future<FinancialCategoryWriteResult> create(FinancialCategory draft) async {
    final fieldsResult = FinancialCategoryValidator.validate(draft);
    if (!fieldsResult.isValid) {
      return FinancialCategoryWriteResult.validationFailed(
        fieldsResult.errors,
      );
    }

    final category = draft.copyWith(id: _uuid.v7(), createdAt: _clock());

    try {
      await _categoryRepository.insert(category);
      return FinancialCategoryWriteResult.success(category);
    } catch (_) {
      return FinancialCategoryWriteResult.failure();
    }
  }

  Future<FinancialCategoryWriteResult> update(
    FinancialCategory category,
  ) async {
    final existing = await _categoryRepository.findById(category.id);
    if (existing == null) {
      return FinancialCategoryWriteResult.notFound();
    }

    final fieldsResult = FinancialCategoryValidator.validate(category);
    if (!fieldsResult.isValid) {
      return FinancialCategoryWriteResult.validationFailed(
        fieldsResult.errors,
      );
    }

    final updated = category.copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
    );

    try {
      await _categoryRepository.update(updated);
      return FinancialCategoryWriteResult.success(updated);
    } catch (_) {
      return FinancialCategoryWriteResult.failure();
    }
  }

  Future<FinancialCategoryDeleteResult> delete(String id) async {
    final existing = await _categoryRepository.findById(id);
    if (existing == null) {
      return const FinancialCategoryDeleteResult(
        status: FinancialCategoryDeleteStatus.notFound,
      );
    }

    final entries = await _entryRepository.listAll();
    final usageCount = entries
        .where((entry) => entry.categoryId == id)
        .length;
    if (usageCount > 0) {
      return FinancialCategoryDeleteResult(
        status: FinancialCategoryDeleteStatus.blockedByUsage,
        blockingEntryCount: usageCount,
      );
    }

    try {
      await _categoryRepository.delete(id);
      return const FinancialCategoryDeleteResult(
        status: FinancialCategoryDeleteStatus.deleted,
      );
    } catch (_) {
      return const FinancialCategoryDeleteResult(
        status: FinancialCategoryDeleteStatus.failure,
      );
    }
  }
}
