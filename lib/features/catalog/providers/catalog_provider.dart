import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/catalog_item.dart';

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
}

final catalogProvider =
    NotifierProvider<CatalogNotifier, List<CatalogItem>>(CatalogNotifier.new);
