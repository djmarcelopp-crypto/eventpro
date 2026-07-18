import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/financial_category_repository.dart';
import '../models/financial_category.dart';
import '../models/financial_category_delete_result.dart';
import '../models/financial_category_write_result.dart';
import '../utils/financial_category_service.dart';
import 'financial_category_repository_provider.dart';
import 'financial_category_service_provider.dart';

class FinancialCategoriesNotifier
    extends AsyncNotifier<List<FinancialCategory>> {
  FinancialCategoryRepository get _repository =>
      ref.read(financialCategoryRepositoryProvider);

  FinancialCategoryService get _service =>
      ref.read(financialCategoryServiceProvider);

  @override
  Future<List<FinancialCategory>> build() async {
    return _repository.listAll();
  }

  void hydrate(List<FinancialCategory> categories) {
    state = AsyncValue.data(List<FinancialCategory>.unmodifiable(categories));
  }

  FinancialCategory? findById(String id) {
    final current = state.value;
    if (current == null) {
      return null;
    }
    for (final category in current) {
      if (category.id == id) {
        return category;
      }
    }
    return null;
  }

  Future<FinancialCategoryWriteResult> addCategory(
    FinancialCategory draft,
  ) async {
    final result = await _service.create(draft);
    if (result.isSuccess && result.category != null) {
      final current = state.value ?? const <FinancialCategory>[];
      final next = [...current, result.category!]
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      state = AsyncValue.data(List<FinancialCategory>.unmodifiable(next));
    }
    return result;
  }

  Future<FinancialCategoryWriteResult> updateCategory(
    FinancialCategory category,
  ) async {
    final result = await _service.update(category);
    if (result.isSuccess && result.category != null) {
      final current = state.value ?? const <FinancialCategory>[];
      final next = [
        for (final item in current)
          if (item.id == result.category!.id) result.category! else item,
      ]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      state = AsyncValue.data(List<FinancialCategory>.unmodifiable(next));
    }
    return result;
  }

  Future<FinancialCategoryDeleteResult> deleteCategory(String id) async {
    final result = await _service.delete(id);
    if (result.isDeleted) {
      final current = state.value ?? const <FinancialCategory>[];
      state = AsyncValue.data(
        List<FinancialCategory>.unmodifiable([
          for (final category in current)
            if (category.id != id) category,
        ]),
      );
    }
    return result;
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.listAll);
  }
}

final financialCategoriesProvider =
    AsyncNotifierProvider<
      FinancialCategoriesNotifier,
      List<FinancialCategory>
    >(FinancialCategoriesNotifier.new);
