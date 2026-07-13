import '../catalog_category.dart';
import '../catalog_item_type.dart';

class CatalogItem {
  const CatalogItem({
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
  });

  final String id;
  final DateTime createdAt;
  final CatalogItemType type;
  final String name;
  final CatalogCategory category;
  final String? description;
  final String unit;
  final double price;
  final bool active;

  /// Optional main image reference for catalog card, details and future PDF use.
  /// Upload and storage are handled in a future task.
  final String? imageReference;

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
  }) {
    return CatalogItem(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: createdAt ?? DateTime.now(),
      type: type,
      name: name.trim(),
      category: category,
      unit: unit.trim(),
      price: price,
      active: active,
      description: _optionalText(description),
      imageReference: _optionalText(imageReference),
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
    bool clearDescription = false,
    bool clearImageReference = false,
  }) {
    return CatalogItem(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      name: name ?? this.name,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      price: price ?? this.price,
      active: active ?? this.active,
      description: clearDescription ? null : (description ?? this.description),
      imageReference:
          clearImageReference ? null : (imageReference ?? this.imageReference),
    );
  }

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}
