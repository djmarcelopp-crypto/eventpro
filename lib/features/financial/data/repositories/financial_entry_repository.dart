import 'package:eventpro/features/financial/models/financial_entry.dart';

/// Domain contract for persisting [FinancialEntry] records (revenues and
/// expenses).
///
/// This is intentionally storage-agnostic: no concrete implementation
/// (Drift-backed or otherwise) exists yet. It only establishes the shape
/// future persistence checkpoints must implement, mirroring the pattern
/// already used by `AgendaBlockRepository` and `QuoteRepository`.
abstract class FinancialEntryRepository {
  Future<List<FinancialEntry>> listAll();

  Future<FinancialEntry?> findById(String id);

  Future<void> insert(FinancialEntry entry);

  Future<void> update(FinancialEntry entry);

  Future<void> delete(String id);
}
