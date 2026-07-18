import 'package:eventpro/features/billing/models/invoice_item_input.dart';
import 'package:eventpro/features/billing/utils/invoice_totals.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceTotals', () {
    test('computes line, subtotal and total', () {
      expect(
        InvoiceTotals.lineTotalCents(quantity: 1.5, unitPriceCents: 1000),
        1500,
      );

      final subtotal = InvoiceTotals.subtotalFromInputs(const [
        InvoiceItemInput(
          description: 'A',
          quantity: 2,
          unitPriceCents: 1000,
        ),
        InvoiceItemInput(
          description: 'B',
          quantity: 1,
          unitPriceCents: 500,
        ),
      ]);
      expect(subtotal, 2500);
      expect(
        InvoiceTotals.totalCents(
          subtotalCents: subtotal,
          taxCents: 250,
          discountCents: 100,
        ),
        2650,
      );
    });
  });
}
