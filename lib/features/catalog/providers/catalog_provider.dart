import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/catalog_repository.dart';
import '../models/catalog_delete_result.dart';
import '../models/catalog_item.dart';
import 'catalog_repository_provider.dart';

class CatalogNotifier extends Notifier<List<CatalogItem>> {
  CatalogRepository get _repository => ref.read(catalogRepositoryProvider);

  @override
  List<CatalogItem> build() => [];

  Future<bool> addItem(CatalogItem item) async {
    try {
      await _repository.insert(item);
      state = [...state, item];
      return true;
    } catch (_) {
      return false;
    }
  }

  CatalogItem? findById(String id) {
    for (final item in state) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  Future<bool> updateItem(
    CatalogItem item, {
    bool clearImageReference = false,
  }) async {
    final existing = findById(item.id);
    if (existing == null) {
      return false;
    }

    final updated = item.copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
      clearImageReference: clearImageReference,
      imageReference: clearImageReference
          ? null
          : (item.imageReference ?? existing.imageReference),
    );

    try {
      await _repository.update(updated);
      state = [
        for (final current in state)
          if (current.id == updated.id) updated else current,
      ];
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<CatalogDeleteResult> deleteItem(String id) async {
    final exists = state.any((item) => item.id == id);
    if (!exists) {
      return const CatalogDeleteResult(status: CatalogDeleteStatus.notFound);
    }

    try {
      await _repository.delete(id);
      state = [
        for (final current in state)
          if (current.id != id) current,
      ];
      return const CatalogDeleteResult(status: CatalogDeleteStatus.deleted);
    } catch (_) {
      return const CatalogDeleteResult(status: CatalogDeleteStatus.failure);
    }
  }
}

final catalogProvider =
    NotifierProvider<CatalogNotifier, List<CatalogItem>>(CatalogNotifier.new);
