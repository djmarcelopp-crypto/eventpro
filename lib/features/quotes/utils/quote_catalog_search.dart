import '../../catalog/catalog_category.dart';
import '../../catalog/catalog_item_type.dart';
import '../../catalog/models/catalog_item.dart';

abstract class QuoteCatalogSearch {
  static List<CatalogItem> filterActive(List<CatalogItem> items, String query) {
    final activeItems = [
      for (final item in items)
        if (item.active) item,
    ];

    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return activeItems;
    }

    return [
      for (final item in activeItems)
        if (matches(item, query)) item,
    ];
  }

  static bool matches(CatalogItem item, String query) {
    if (!item.active) {
      return false;
    }

    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final fields = <String>[
      item.name,
      item.category.label,
      item.type.label,
      item.unit,
    ];

    for (final field in fields) {
      if (_normalize(field).contains(normalizedQuery)) {
        return true;
      }
    }

    return false;
  }

  static String _normalize(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
  }
}
