import 'quote_equipment.dart';

/// Aggregated equipment lines for a single quote (TASK-028 CP-D).
///
/// Pure snapshot of [QuoteEquipment] rows — never computes availability,
/// never reserves stock, never mutates equipment status.
class QuoteEquipmentSummary {
  QuoteEquipmentSummary({
    required this.quoteId,
    required List<QuoteEquipment> items,
  }) : items = List.unmodifiable(items);

  final String quoteId;

  /// Equipment lines linked to [quoteId], typically ordered by creation.
  final List<QuoteEquipment> items;

  int get lineCount => items.length;

  int get totalQuantity =>
      items.fold<int>(0, (sum, item) => sum + item.quantity);

  bool get hasItems => items.isNotEmpty;
}
