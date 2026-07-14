import '../catalog_item_type.dart';
import '../models/catalog_item.dart';

abstract class CatalogPackageComponentSearch {
  static List<CatalogItem> filterSelectable({
    required List<CatalogItem> items,
    required Set<String> excludedIds,
    String query = '',
  }) {
    final normalizedQuery = query.trim().toLowerCase();

    return items.where((item) {
      if (!item.active) {
        return false;
      }
      if (item.type == CatalogItemType.package) {
        return false;
      }
      if (!item.type.canBePackageComponent) {
        return false;
      }
      if (excludedIds.contains(item.id)) {
        return false;
      }
      if (normalizedQuery.isNotEmpty &&
          !item.name.toLowerCase().contains(normalizedQuery)) {
        return false;
      }
      return true;
    }).toList();
  }
}
