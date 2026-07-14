import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/catalog_item.dart';
import '../models/catalog_delete_result.dart';

class CatalogNotifier extends Notifier<List<CatalogItem>> {
  @override
  List<CatalogItem> build() => [];

  void addItem(CatalogItem item) {
    state = [...state, item];
  }

  CatalogItem? findById(String id) {
    for (final item in state) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  void updateItem(CatalogItem item, {bool clearImageReference = false}) {
    final existing = findById(item.id);
    if (existing == null) {
      return;
    }

    final updated = item.copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
      clearImageReference: clearImageReference,
      imageReference: clearImageReference
          ? null
          : (item.imageReference ?? existing.imageReference),
    );

    state = [
      for (final current in state)
        if (current.id == updated.id) updated else current,
    ];
  }

  CatalogDeleteResult deleteItem(String id) {
    final exists = state.any((item) => item.id == id);
    if (!exists) {
      return const CatalogDeleteResult(status: CatalogDeleteStatus.notFound);
    }

    state = [
      for (final current in state)
        if (current.id != id) current,
    ];

    return const CatalogDeleteResult(status: CatalogDeleteStatus.deleted);
  }
}

final catalogProvider =
    NotifierProvider<CatalogNotifier, List<CatalogItem>>(CatalogNotifier.new);
