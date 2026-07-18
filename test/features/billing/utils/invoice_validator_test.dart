import 'package:eventpro/features/billing/models/invoice.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:eventpro/features/billing/utils/invoice_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceValidator', () {
    final now = DateTime(2026, 7, 17);

    test('accepts valid fields', () {
      final result = InvoiceValidator.validateFields(
        quoteId: 'quote-1',
        invoiceNumber: 'INV-1',
        type: InvoiceType.service,
        status: InvoiceStatus.draft,
        subtotalCents: 100,
        taxCents: 10,
        discountCents: 5,
        totalCents: 105,
      );
      expect(result.isValid, isTrue);
    });

    test('rejects missing required fields and negatives', () {
      final result = InvoiceValidator.validateFields(
        quoteId: ' ',
        invoiceNumber: '',
        type: null,
        status: null,
        subtotalCents: -1,
        taxCents: -1,
        discountCents: -1,
        totalCents: -1,
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(InvoiceValidator.quoteIdRequiredError));
      expect(
        result.errors,
        contains(InvoiceValidator.invoiceNumberRequiredError),
      );
      expect(result.errors, contains(InvoiceValidator.typeRequiredError));
      expect(result.errors, contains(InvoiceValidator.statusRequiredError));
      expect(result.errors, contains(InvoiceValidator.subtotalNegativeError));
      expect(result.errors, contains(InvoiceValidator.taxNegativeError));
      expect(result.errors, contains(InvoiceValidator.discountNegativeError));
      expect(result.errors, contains(InvoiceValidator.totalNegativeError));
    });

    test('validate delegates to fields of Invoice', () {
      final invoice = Invoice(
        id: 'inv-1',
        quoteId: 'quote-1',
        invoiceNumber: 'INV-1',
        type: InvoiceType.mixed,
        status: InvoiceStatus.draft,
        subtotalCents: 0,
        taxCents: 0,
        discountCents: 0,
        totalCents: 0,
        createdAt: now,
        updatedAt: now,
      );
      expect(InvoiceValidator.validate(invoice).isValid, isTrue);
    });
  });
}
