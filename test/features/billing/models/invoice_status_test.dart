import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceStatus', () {
    test('contains all lifecycle values', () {
      expect(InvoiceStatus.values, [
        InvoiceStatus.draft,
        InvoiceStatus.issued,
        InvoiceStatus.paid,
        InvoiceStatus.cancelled,
      ]);
    });

    test('labels are defined for every value', () {
      for (final status in InvoiceStatus.values) {
        expect(status.label, isNotEmpty);
      }
    });
  });
}
