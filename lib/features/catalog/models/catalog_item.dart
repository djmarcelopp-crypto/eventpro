import '../catalog_category.dart';
import '../catalog_item_type.dart';
import '../catalog_package_constants.dart';
import 'catalog_package_component.dart';

class CatalogItem {
  CatalogItem({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.name,
    required this.category,
    required this.unit,
    required this.price,
    required this.active,
    this.description,
    this.imageReference,
    List<CatalogPackageComponent>? components,
  }) : components = List.unmodifiable(
          _normalizedComponents(
            type: type,
            components: components,
          ),
        );

  final String id;
  final DateTime createdAt;
  final CatalogItemType type;
  final String name;
  final CatalogCategory category;
  final String? description;
  final String unit;
  final double price;
  final bool active;
  final String? imageReference;
  final List<CatalogPackageComponent> components;

  bool get isPackage => type.isPackage;

  factory CatalogItem.fromForm({
    required CatalogItemType type,
    required String name,
    required CatalogCategory category,
    required String unit,
    required double price,
    bool active = true,
    String? description,
    String? imageReference,
    String? id,
    DateTime? createdAt,
    List<CatalogPackageComponent>? components,
  }) {
    final normalizedComponents = _normalizedComponents(
      type: type,
      components: components,
    );
    final normalizedUnit = type.isPackage ? CatalogPackageConstants.unit : unit.trim();

    return CatalogItem(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: createdAt ?? DateTime.now(),
      type: type,
      name: name.trim(),
      category: category,
      unit: normalizedUnit,
      price: price,
      active: active,
      description: _optionalText(description),
      imageReference: _optionalText(imageReference),
      components: normalizedComponents,
    );
  }

  CatalogItem copyWith({
    String? id,
    DateTime? createdAt,
    CatalogItemType? type,
    String? name,
    CatalogCategory? category,
    String? unit,
    double? price,
    bool? active,
    String? description,
    String? imageReference,
    List<CatalogPackageComponent>? components,
    bool clearDescription = false,
    bool clearImageReference = false,
    bool clearComponents = false,
  }) {
    final resolvedType = type ?? this.type;
    final resolvedComponents = clearComponents
        ? const <CatalogPackageComponent>[]
        : (components ?? this.components);

    return CatalogItem(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: resolvedType,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: resolvedType.isPackage
          ? CatalogPackageConstants.unit
          : (unit ?? this.unit),
      price: price ?? this.price,
      active: active ?? this.active,
      description: clearDescription ? null : (description ?? this.description),
      imageReference:
          clearImageReference ? null : (imageReference ?? this.imageReference),
      components: _normalizedComponents(
        type: resolvedType,
        components: resolvedComponents,
      ),
    );
  }

  static List<CatalogPackageComponent> _normalizedComponents({
    required CatalogItemType type,
    required List<CatalogPackageComponent>? components,
  }) {
    final source = components ?? const <CatalogPackageComponent>[];
    if (!type.isPackage) {
      return const [];
    }

    return List.unmodifiable(source);
  }

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
