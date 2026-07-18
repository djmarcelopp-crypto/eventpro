import '../models/invoice_item.dart';
import '../models/invoice_item_input.dart';

/// Pure helpers for invoice monetary calculations.
abstract class InvoiceTotals {
  static int lineTotalCents({
    required double quantity,
    required int unitPriceCents,
  }) {
    return (quantity * unitPriceCents).round();
  }

  static int subtotalFromInputs(List<InvoiceItemInput> items) {
    var subtotal = 0;
    for (final item in items) {
      subtotal += lineTotalCents(
        quantity: item.quantity,
        unitPriceCents: item.unitPriceCents,
      );
    }
    return subtotal;
  }

  static int subtotalFromItems(List<InvoiceItem> items) {
    var subtotal = 0;
    for (final item in items) {
      subtotal += item.totalPriceCents;
    }
    return subtotal;
  }

  static int totalCents({
    required int subtotalCents,
    required int taxCents,
    required int discountCents,
  }) {
    return subtotalCents + taxCents - discountCents;
  }
}
