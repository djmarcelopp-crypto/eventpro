import '../../catalog/models/catalog_item.dart';
import '../utils/quote_calculator.dart';
import '../utils/quote_money.dart';
import '../utils/quote_package_component_mapper.dart';
import '../utils/quote_quantity_validator.dart';
import 'quote_package_component_snapshot.dart';

class QuoteLineItem {
  QuoteLineItem({
    this.catalogItemId,
    required this.name,
    this.description,
    required this.unit,
    required this.quantity,
    required this.unitPriceCents,
    required this.lineTotalCents,
    List<QuotePackageComponentSnapshot>? packageComponents,
  }) : packageComponents = packageComponents == null
            ? null
            : List.unmodifiable(packageComponents);

  final String? catalogItemId;
  final String name;
  final String? description;
  final String unit;
  final double quantity;
  final int unitPriceCents;
  final int lineTotalCents;
  final List<QuotePackageComponentSnapshot>? packageComponents;

  bool get isPackageLine => packageComponents != null;

  factory QuoteLineItem.fromCatalogItem(
    CatalogItem item, {
    required double quantity,
  }) {
    if (!QuoteQuantityValidator.isValid(quantity)) {
      throw ArgumentError.value(quantity, 'quantity', 'Invalid quantity');
    }

    final unitPriceCents = QuoteMoney.reaisToCents(item.price);
    final packageComponents = item.isPackage
        ? QuotePackageComponentMapper.fromCatalogComponents(item.components)
        : null;

    return QuoteLineItem(
      catalogItemId: item.id,
      name: item.name,
      description: item.description,
      unit: item.unit,
      quantity: quantity,
      unitPriceCents: unitPriceCents,
      lineTotalCents: QuoteCalculator.lineTotalCents(
        quantity: quantity,
        unitPriceCents: unitPriceCents,
      ),
      packageComponents: packageComponents,
    );
  }

  QuoteLineItem copyWith({
    String? catalogItemId,
    String? name,
    String? description,
    String? unit,
    double? quantity,
    int? unitPriceCents,
    int? lineTotalCents,
    List<QuotePackageComponentSnapshot>? packageComponents,
    bool clearCatalogItemId = false,
    bool clearDescription = false,
    bool clearPackageComponents = false,
  }) {
    final resolvedPackageComponents = clearPackageComponents
        ? null
        : (packageComponents ?? this.packageComponents);

    return QuoteLineItem(
      catalogItemId:
          clearCatalogItemId ? null : (catalogItemId ?? this.catalogItemId),
      name: name ?? this.name,
      description: clearDescription ? null : (description ?? this.description),
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      unitPriceCents: unitPriceCents ?? this.unitPriceCents,
      lineTotalCents: lineTotalCents ?? this.lineTotalCents,
      packageComponents: resolvedPackageComponents,
    );
  }
}
