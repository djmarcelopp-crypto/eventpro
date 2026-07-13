import '../models/quote_line_item.dart';

abstract class QuoteCalculator {
  static int lineTotalCents({
    required double quantity,
    required int unitPriceCents,
  }) {
    return (quantity * unitPriceCents).round();
  }

  static int subtotalCents(List<QuoteLineItem> items) {
    var total = 0;
    for (final item in items) {
      total += item.lineTotalCents;
    }
    return total;
  }

  static int totalCents({
    required int subtotalCents,
    required int discountCents,
    required int freightCents,
  }) {
    final total = subtotalCents - discountCents + freightCents;
    return total < 0 ? 0 : total;
  }

  static QuoteLineItem withCalculatedLineTotal(QuoteLineItem item) {
    return item.copyWith(
      lineTotalCents: lineTotalCents(
        quantity: item.quantity,
        unitPriceCents: item.unitPriceCents,
      ),
    );
  }
}
