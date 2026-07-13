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

  void updateItem(CatalogItem item) {
    final existing = findById(item.id);
    if (existing == null) {
      return;
    }

    final updated = item.copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
    );

    state = [
      for (final current in state)
        if (current.id == updated.id) updated else current,
    ];
  }

  void deleteItem(String id) {
    state = [
      for (final item in state)
        if (item.id != id) item,
    ];
  }
}

final catalogProvider =
    NotifierProvider<CatalogNotifier, List<CatalogItem>>(CatalogNotifier.new);
