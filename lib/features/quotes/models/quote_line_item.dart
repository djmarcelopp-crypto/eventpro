import '../../catalog/models/catalog_item.dart';
import '../utils/quote_calculator.dart';
import '../utils/quote_money.dart';
import '../utils/quote_quantity_validator.dart';

class QuoteLineItem {
  const QuoteLineItem({
    this.catalogItemId,
    required this.name,
    this.description,
    required this.unit,
    required this.quantity,
    required this.unitPriceCents,
    required this.lineTotalCents,
  });

  final String? catalogItemId;
  final String name;
  final String? description;
  final String unit;
  final double quantity;
  final int unitPriceCents;
  final int lineTotalCents;

  factory QuoteLineItem.fromCatalogItem(
    CatalogItem item, {
    required double quantity,
  }) {
    if (!QuoteQuantityValidator.isValid(quantity)) {
      throw ArgumentError.value(quantity, 'quantity', 'Invalid quantity');
    }

    final unitPriceCents = QuoteMoney.reaisToCents(item.price);
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
    bool clearCatalogItemId = false,
    bool clearDescription = false,
  }) {
    return QuoteLineItem(
      catalogItemId:
          clearCatalogItemId ? null : (catalogItemId ?? this.catalogItemId),
      name: name ?? this.name,
      description: clearDescription ? null : (description ?? this.description),
      unit: unit ?? this.unit,
      quantity: quantity ?? this.quantity,
      unitPriceCents: unitPriceCents ?? this.unitPriceCents,
      lineTotalCents: lineTotalCents ?? this.lineTotalCents,
    );
  }
}
