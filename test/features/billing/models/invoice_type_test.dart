import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceType', () {
    test('contains all type values', () {
      expect(InvoiceType.values, [
        InvoiceType.service,
        InvoiceType.product,
        InvoiceType.mixed,
      ]);
    });

    test('labels are defined for every value', () {
      for (final type in InvoiceType.values) {
        expect(type.label, isNotEmpty);
      }
    });
  });
}
