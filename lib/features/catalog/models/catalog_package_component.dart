import '../catalog_category.dart';
import '../catalog_item_type.dart';
import 'catalog_item.dart';
import '../utils/catalog_quantity_validator.dart';

class CatalogPackageComponent {
  const CatalogPackageComponent({
    required this.catalogItemId,
    required this.nameSnapshot,
    required this.unitSnapshot,
    required this.typeSnapshot,
    required this.categorySnapshot,
    required this.quantityPerPackage,
  });

  final String catalogItemId;
  final String nameSnapshot;
  final String unitSnapshot;
  final String typeSnapshot;
  final String categorySnapshot;
  final double quantityPerPackage;

  factory CatalogPackageComponent.fromCatalogItem({
    required CatalogItem item,
    required double quantityPerPackage,
  }) {
    if (item.type == CatalogItemType.package) {
      throw ArgumentError.value(
        item.type,
        'item.type',
        'Packages cannot be nested as components',
      );
    }

    if (!CatalogQuantityValidator.isValid(quantityPerPackage)) {
      throw ArgumentError.value(
        quantityPerPackage,
        'quantityPerPackage',
        'Invalid quantity per package',
      );
    }

    return CatalogPackageComponent(
      catalogItemId: item.id,
      nameSnapshot: item.name.trim(),
      unitSnapshot: item.unit.trim(),
      typeSnapshot: item.type.label,
      categorySnapshot: item.category.label,
      quantityPerPackage: quantityPerPackage,
    );
  }

  CatalogPackageComponent copyWith({
    String? catalogItemId,
    String? nameSnapshot,
    String? unitSnapshot,
    String? typeSnapshot,
    String? categorySnapshot,
    double? quantityPerPackage,
  }) {
    return CatalogPackageComponent(
      catalogItemId: catalogItemId ?? this.catalogItemId,
      nameSnapshot: nameSnapshot ?? this.nameSnapshot,
      unitSnapshot: unitSnapshot ?? this.unitSnapshot,
      typeSnapshot: typeSnapshot ?? this.typeSnapshot,
      categorySnapshot: categorySnapshot ?? this.categorySnapshot,
      quantityPerPackage: quantityPerPackage ?? this.quantityPerPackage,
    );
  }
}
