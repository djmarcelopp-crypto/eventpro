import '../models/catalog_item.dart';

abstract class CatalogPackageDependencyChecker {
  static List<CatalogItem> findDependentPackages({
    required String catalogItemId,
    required List<CatalogItem> items,
  }) {
    return items
        .where(
          (item) =>
              item.isPackage &&
              item.components.any(
                (component) => component.catalogItemId == catalogItemId,
              ),
        )
        .toList();
  }

  static List<String> dependentPackageNames({
    required String catalogItemId,
    required List<CatalogItem> items,
  }) {
    return findDependentPackages(
      catalogItemId: catalogItemId,
      items: items,
    )
        .map((item) => item.name.trim())
        .where((name) => name.isNotEmpty)
        .toList();
  }
}
