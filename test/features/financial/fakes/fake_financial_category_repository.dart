import 'package:eventpro/features/financial/data/repositories/financial_category_repository.dart';
import 'package:eventpro/features/financial/models/financial_category.dart';

class FakeFinancialCategoryRepository implements FinancialCategoryRepository {
  FakeFinancialCategoryRepository({List<FinancialCategory>? initialCategories})
    : _categories = List<FinancialCategory>.from(
        initialCategories ?? const [],
      );

  final List<FinancialCategory> _categories;

  /// Makes the next write (insert/update/delete) throw once, then resets
  /// itself. Reads (listAll/findById) are never affected, so tests can
  /// simulate a write failure without also breaking the existence checks
  /// `FinancialCategoryService` performs before writing.
  var shouldFailOnNextOperation = false;

  @override
  Future<List<FinancialCategory>> listAll() async {
    return List<FinancialCategory>.unmodifiable(_categories);
  }

  @override
  Future<FinancialCategory?> findById(String id) async {
    for (final category in _categories) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }

  @override
  Future<void> insert(FinancialCategory category) async {
    _failIfRequested();
    _categories.add(category);
  }

  @override
  Future<void> update(FinancialCategory category) async {
    _failIfRequested();
    final index = _categories.indexWhere((item) => item.id == category.id);
    if (index == -1) {
      throw StateError('FinancialCategory not found for update: ${category.id}');
    }
    _categories[index] = category;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _categories.length;
    _categories.removeWhere((category) => category.id == id);
    if (_categories.length == lengthBefore) {
      throw StateError('FinancialCategory not found for delete: $id');
    }
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) {
      return;
    }
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}
