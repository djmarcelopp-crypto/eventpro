import 'package:eventpro/features/financial/models/financial_category.dart';

/// Domain contract for persisting [FinancialCategory] records.
///
/// This is intentionally storage-agnostic: no concrete implementation
/// (Drift-backed or otherwise) exists yet. It only establishes the shape
/// future persistence checkpoints must implement, mirroring the pattern
/// already used by `AgendaBlockRepository` and `QuoteRepository`.
abstract class FinancialCategoryRepository {
  Future<List<FinancialCategory>> listAll();

  Future<FinancialCategory?> findById(String id);

  Future<void> insert(FinancialCategory category);

  Future<void> update(FinancialCategory category);

  Future<void> delete(String id);
}
