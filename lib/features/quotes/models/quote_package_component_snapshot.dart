class QuotePackageComponentSnapshot {
  const QuotePackageComponentSnapshot({
    this.catalogItemId,
    required this.name,
    required this.unit,
    required this.typeLabel,
    required this.categoryLabel,
    required this.quantityPerPackage,
  });

  final String? catalogItemId;
  final String name;
  final String unit;
  final String typeLabel;
  final String categoryLabel;
  final double quantityPerPackage;

  double effectiveQuantity(double lineQuantity) {
    return quantityPerPackage * lineQuantity;
  }

  QuotePackageComponentSnapshot copyWith({
    String? catalogItemId,
    String? name,
    String? unit,
    String? typeLabel,
    String? categoryLabel,
    double? quantityPerPackage,
    bool clearCatalogItemId = false,
  }) {
    return QuotePackageComponentSnapshot(
      catalogItemId:
          clearCatalogItemId ? null : (catalogItemId ?? this.catalogItemId),
      name: name ?? this.name,
      unit: unit ?? this.unit,
      typeLabel: typeLabel ?? this.typeLabel,
      categoryLabel: categoryLabel ?? this.categoryLabel,
      quantityPerPackage: quantityPerPackage ?? this.quantityPerPackage,
    );
  }
}
