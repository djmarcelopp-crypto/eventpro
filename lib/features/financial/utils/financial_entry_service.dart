import 'package:uuid/uuid.dart';

import '../data/repositories/financial_category_repository.dart';
import '../data/repositories/financial_entry_repository.dart';
import '../models/financial_entry.dart';
import '../models/financial_entry_delete_result.dart';
import '../models/financial_entry_status.dart';
import '../models/financial_entry_write_result.dart';
import '../models/financial_flow_kind.dart';
import 'financial_entry_validator.dart';

/// Coordinates validation and persistence for [FinancialEntry] writes.
///
/// Repositories stay limited to reading/writing rows; every business rule
/// (field validation, category existence/activeness/kind match, and the
/// `status`/`paidAt` consistency rule) lives here, never in
/// `FinancialEntryRepository`/`DriftFinancialEntryRepository`.
class FinancialEntryService {
  FinancialEntryService({
    required FinancialEntryRepository entryRepository,
    required FinancialCategoryRepository categoryRepository,
    DateTime Function()? clock,
  }) : _entryRepository = entryRepository,
       _categoryRepository = categoryRepository,
       _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final FinancialEntryRepository _entryRepository;
  final FinancialCategoryRepository _categoryRepository;

  /// Injectable clock — defaults to [DateTime.now], overridable in tests.
  /// Never call [DateTime.now] directly anywhere else in this class.
  final DateTime Function() _clock;

  Future<FinancialEntryWriteResult> create(FinancialEntry draft) async {
    final fieldsResult = FinancialEntryValidator.validate(draft);
    if (!fieldsResult.isValid) {
      return FinancialEntryWriteResult.validationFailed(fieldsResult.errors);
    }

    final categoryError = await _checkCategory(
      categoryId: draft.categoryId,
      kind: draft.kind,
    );
    if (categoryError != null) {
      return categoryError;
    }

    final now = _clock();
    final normalized = _normalizeStatus(draft, now: now).copyWith(
      id: _uuid.v7(),
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _entryRepository.insert(normalized);
      return FinancialEntryWriteResult.success(normalized);
    } catch (_) {
      return FinancialEntryWriteResult.failure();
    }
  }

  Future<FinancialEntryWriteResult> update(FinancialEntry entry) async {
    final existing = await _entryRepository.findById(entry.id);
    if (existing == null) {
      return FinancialEntryWriteResult.notFound();
    }

    final fieldsResult = FinancialEntryValidator.validate(entry);
    if (!fieldsResult.isValid) {
      return FinancialEntryWriteResult.validationFailed(fieldsResult.errors);
    }

    final categoryError = await _checkCategory(
      categoryId: entry.categoryId,
      kind: entry.kind,
    );
    if (categoryError != null) {
      return categoryError;
    }

    final now = _clock();
    final normalized = _normalizeStatus(entry, now: now).copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
      updatedAt: now,
    );

    try {
      await _entryRepository.update(normalized);
      return FinancialEntryWriteResult.success(normalized);
    } catch (_) {
      return FinancialEntryWriteResult.failure();
    }
  }

  Future<FinancialEntryDeleteResult> delete(String id) async {
    final existing = await _entryRepository.findById(id);
    if (existing == null) {
      return const FinancialEntryDeleteResult(
        status: FinancialEntryDeleteStatus.notFound,
      );
    }

    try {
      await _entryRepository.delete(id);
      return const FinancialEntryDeleteResult(
        status: FinancialEntryDeleteStatus.deleted,
      );
    } catch (_) {
      return const FinancialEntryDeleteResult(
        status: FinancialEntryDeleteStatus.failure,
      );
    }
  }

  Future<FinancialEntryWriteResult?> _checkCategory({
    required String categoryId,
    required FinancialFlowKind kind,
  }) async {
    final category = await _categoryRepository.findById(categoryId);
    if (category == null) {
      return FinancialEntryWriteResult.categoryNotFound();
    }
    if (!category.active) {
      return FinancialEntryWriteResult.categoryInactive();
    }
    if (category.kind != kind) {
      return FinancialEntryWriteResult.categoryKindMismatch();
    }
    return null;
  }

  /// Enforces the `status`/`paidAt` consistency rule: [FinancialEntryStatus.paid]
  /// always has a non-null `paidAt` (filled from [_clock] when not informed);
  /// [FinancialEntryStatus.pending] always has `paidAt == null`.
  FinancialEntry _normalizeStatus(
    FinancialEntry entry, {
    required DateTime now,
  }) {
    if (entry.status == FinancialEntryStatus.paid) {
      return entry.paidAt == null ? entry.copyWith(paidAt: now) : entry;
    }
    return entry.copyWith(clearPaidAt: true);
  }
}
