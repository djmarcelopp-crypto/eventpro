import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/financial/data/mappers/financial_entry_mapper.dart';
import 'package:eventpro/features/financial/data/repositories/financial_entry_repository.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';

class DriftFinancialEntryRepository implements FinancialEntryRepository {
  DriftFinancialEntryRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<FinancialEntry>> listAll() async {
    final rows = await _database.financialEntriesDao.getAllOrdered();
    return rows.map(FinancialEntryMapper.toDomain).toList(growable: false);
  }

  @override
  Future<FinancialEntry?> findById(String id) async {
    final row = await _database.financialEntriesDao.getById(id);
    if (row == null) {
      return null;
    }
    return FinancialEntryMapper.toDomain(row);
  }

  @override
  Future<void> insert(FinancialEntry entry) async {
    await _database.financialEntriesDao.insertRow(
      FinancialEntryMapper.toInsertCompanion(entry),
    );
  }

  @override
  Future<void> update(FinancialEntry entry) async {
    final updated = await _database.financialEntriesDao.updateRow(
      FinancialEntryMapper.toUpdateCompanion(entry),
    );
    if (!updated) {
      throw StateError('FinancialEntry not found for update: ${entry.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.financialEntriesDao.deleteById(id);
    if (!deleted) {
      throw StateError('FinancialEntry not found for delete: $id');
    }
  }
}
