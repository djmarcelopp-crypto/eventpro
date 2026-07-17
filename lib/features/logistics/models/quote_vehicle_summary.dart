import 'quote_vehicle.dart';

/// Aggregated vehicle lines for a single quote.
class QuoteVehicleSummary {
  QuoteVehicleSummary({
    required this.quoteId,
    required List<QuoteVehicle> items,
  }) : items = List.unmodifiable(items);

  final String quoteId;
  final List<QuoteVehicle> items;

  int get lineCount => items.length;

  int get totalFreightCostCents =>
      items.fold<int>(0, (sum, item) => sum + item.freightCostCents);

  bool get hasItems => items.isNotEmpty;
}
