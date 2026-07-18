import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';

abstract class CatalogItemMapper {
  static CatalogItem toDomain(
    CatalogItemRow row, {
    List<CatalogPackageComponentRow> components = const [],
  }) {
    return CatalogItem(
      id: row.id,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      type: _parseType(row.type),
      name: row.name,
      category: _parseCategory(row.category),
      unit: row.unit,
      price: _centsToReais(row.priceCents),
      active: row.active,
      description: row.description,
      imageReference: row.imageReference,
      components: components.map(_componentToDomain).toList(),
    );
  }

  static CatalogItemsCompanion toInsertCompanion(CatalogItem item) {
    return _toCompanion(item);
  }

  static CatalogItemsCompanion toUpdateCompanion(CatalogItem item) {
    return _toCompanion(item);
  }

  static List<CatalogPackageComponentsCompanion> toComponentCompanions(
    CatalogItem item,
  ) {
    return item.components
        .map(
          (component) => CatalogPackageComponentsCompanion.insert(
            packageId: item.id,
            componentItemId: component.catalogItemId,
            nameSnapshot: component.nameSnapshot,
            unitSnapshot: component.unitSnapshot,
            typeSnapshot: component.typeSnapshot,
            categorySnapshot: component.categorySnapshot,
            quantityPerPackage: component.quantityPerPackage,
          ),
        )
        .toList(growable: false);
  }

  static CatalogItemsCompanion _toCompanion(CatalogItem item) {
    return CatalogItemsCompanion.insert(
      id: item.id,
      createdAt: TimestampConverter.toUtcMillis(item.createdAt),
      type: item.type.name,
      name: item.name,
      category: item.category.name,
      description: Value(item.description),
      unit: item.unit,
      priceCents: _reaisToCents(item.price),
      active: item.active,
      imageReference: Value(item.imageReference),
    );
  }

  static CatalogPackageComponent _componentToDomain(
    CatalogPackageComponentRow row,
  ) {
    return CatalogPackageComponent(
      catalogItemId: row.componentItemId,
      nameSnapshot: row.nameSnapshot,
      unitSnapshot: row.unitSnapshot,
      typeSnapshot: row.typeSnapshot,
      categorySnapshot: row.categorySnapshot,
      quantityPerPackage: row.quantityPerPackage,
    );
  }

  static int _reaisToCents(double reais) => (reais * 100).round();

  static double _centsToReais(int cents) => cents / 100;

  static CatalogItemType _parseType(String value) {
    return CatalogItemType.values.firstWhere((type) => type.name == value);
  }

  static CatalogCategory _parseCategory(String value) {
    return CatalogCategory.values.firstWhere(
      (category) => category.name == value,
    );
  }
}
