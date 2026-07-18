import 'package:eventpro/features/billing/models/invoice_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceItem', () {
    InvoiceItem buildItem({
      String id = 'item-1',
      String description = 'Som',
      double quantity = 2,
    }) {
      return InvoiceItem(
        id: id,
        invoiceId: 'inv-1',
        description: description,
        quantity: quantity,
        unitPriceCents: 5_000,
        totalPriceCents: 10_000,
      );
    }

    test('equality compares all fields', () {
      final a = buildItem();
      final b = buildItem();
      final different = buildItem(description: 'Iluminação');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(different)));
    });

    test('copyWith overrides selected fields', () {
      final original = buildItem();
      final copy = original.copyWith(quantity: 3, totalPriceCents: 15_000);

      expect(copy.quantity, 3);
      expect(copy.totalPriceCents, 15_000);
      expect(copy.invoiceId, original.invoiceId);
      expect(copy.description, original.description);
    });
  });
}
