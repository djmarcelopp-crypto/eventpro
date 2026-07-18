import 'package:eventpro/features/billing/models/invoice_item.dart';
import 'package:eventpro/features/billing/utils/invoice_item_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceItemValidator', () {
    test('accepts valid fields', () {
      final result = InvoiceItemValidator.validateFields(
        invoiceId: 'inv-1',
        description: 'Som',
        quantity: 1.5,
        unitPriceCents: 1000,
        totalPriceCents: 1500,
      );
      expect(result.isValid, isTrue);
    });

    test('rejects invalid fields', () {
      final result = InvoiceItemValidator.validateFields(
        invoiceId: '',
        description: ' ',
        quantity: 0,
        unitPriceCents: -1,
        totalPriceCents: -1,
      );

      expect(result.isValid, isFalse);
      expect(
        result.errors,
        contains(InvoiceItemValidator.invoiceIdRequiredError),
      );
      expect(
        result.errors,
        contains(InvoiceItemValidator.descriptionRequiredError),
      );
      expect(
        result.errors,
        contains(InvoiceItemValidator.quantityInvalidError),
      );
      expect(
        result.errors,
        contains(InvoiceItemValidator.unitPriceNegativeError),
      );
      expect(
        result.errors,
        contains(InvoiceItemValidator.totalPriceNegativeError),
      );
    });

    test('validate delegates to InvoiceItem', () {
      final item = InvoiceItem(
        id: 'item-1',
        invoiceId: 'inv-1',
        description: 'Som',
        quantity: 2,
        unitPriceCents: 500,
        totalPriceCents: 1000,
      );
      expect(InvoiceItemValidator.validate(item).isValid, isTrue);
    });
  });
}
