import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/financial/data/mappers/financial_category_mapper.dart';
import 'package:eventpro/features/financial/data/repositories/financial_category_repository.dart';
import 'package:eventpro/features/financial/models/financial_category.dart';

class DriftFinancialCategoryRepository
    implements FinancialCategoryRepository {
  DriftFinancialCategoryRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<FinancialCategory>> listAll() async {
    final rows = await _database.financialCategoriesDao.getAllOrdered();
    return rows.map(FinancialCategoryMapper.toDomain).toList(growable: false);
  }

  @override
  Future<FinancialCategory?> findById(String id) async {
    final row = await _database.financialCategoriesDao.getById(id);
    if (row == null) {
      return null;
    }
    return FinancialCategoryMapper.toDomain(row);
  }

  @override
  Future<void> insert(FinancialCategory category) async {
    await _database.financialCategoriesDao.insertRow(
      FinancialCategoryMapper.toInsertCompanion(category),
    );
  }

  @override
  Future<void> update(FinancialCategory category) async {
    final updated = await _database.financialCategoriesDao.updateRow(
      FinancialCategoryMapper.toUpdateCompanion(category),
    );
    if (!updated) {
      throw StateError(
        'FinancialCategory not found for update: ${category.id}',
      );
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.financialCategoriesDao.deleteById(id);
    if (!deleted) {
      throw StateError('FinancialCategory not found for delete: $id');
    }
  }
}
