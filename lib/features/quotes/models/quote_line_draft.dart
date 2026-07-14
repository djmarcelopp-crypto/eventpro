import 'quote_package_component_snapshot.dart';

class QuoteLineDraft {
  QuoteLineDraft({
    required this.draftId,
    required this.catalogItemId,
    required this.name,
    this.description,
    required this.unit,
    required this.quantityText,
    required this.priceText,
    required this.isExistingLine,
    List<QuotePackageComponentSnapshot>? packageComponents,
  }) : packageComponents = packageComponents == null
            ? null
            : List.unmodifiable(packageComponents);

  final String draftId;
  final String catalogItemId;
  final String name;
  final String? description;
  final String unit;
  final String quantityText;
  final String priceText;
  final bool isExistingLine;
  final List<QuotePackageComponentSnapshot>? packageComponents;

  bool get isPackageLine => packageComponents != null;

  QuoteLineDraft copyWith({
    String? quantityText,
    String? priceText,
    List<QuotePackageComponentSnapshot>? packageComponents,
    bool clearPackageComponents = false,
  }) {
    final resolvedPackageComponents = clearPackageComponents
        ? null
        : (packageComponents ?? this.packageComponents);

    return QuoteLineDraft(
      draftId: draftId,
      catalogItemId: catalogItemId,
      name: name,
      description: description,
      unit: unit,
      quantityText: quantityText ?? this.quantityText,
      priceText: priceText ?? this.priceText,
      isExistingLine: isExistingLine,
      packageComponents: resolvedPackageComponents,
    );
  }
}
