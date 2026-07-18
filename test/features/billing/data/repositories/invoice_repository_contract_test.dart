import 'package:eventpro/features/billing/data/repositories/invoice_item_repository.dart';
import 'package:eventpro/features/billing/data/repositories/invoice_repository.dart';
import 'package:eventpro/features/billing/models/invoice.dart';
import 'package:eventpro/features/billing/models/invoice_item.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_invoice_item_repository.dart';
import '../../fakes/fake_invoice_repository.dart';

void main() {
  group('InvoiceRepository / InvoiceItemRepository contracts', () {
    final now = DateTime(2026, 7, 17);

    test('invoice insert, find, listByQuoteId, update and delete', () async {
      final InvoiceRepository repository = FakeInvoiceRepository();
      final invoice = Invoice(
        id: 'inv-1',
        quoteId: 'quote-1',
        invoiceNumber: 'INV-1',
        type: InvoiceType.service,
        status: InvoiceStatus.draft,
        subtotalCents: 1000,
        taxCents: 0,
        discountCents: 0,
        totalCents: 1000,
        createdAt: now,
        updatedAt: now,
      );

      await repository.insert(invoice);
      expect(await repository.findById('inv-1'), invoice);
      expect(await repository.listByQuoteId('quote-1'), [invoice]);

      final updated = invoice.copyWith(status: InvoiceStatus.issued);
      await repository.update(updated);
      expect((await repository.findById('inv-1'))!.status, InvoiceStatus.issued);

      await repository.delete('inv-1');
      expect(await repository.findById('inv-1'), isNull);
    });

    test('invoice item listByInvoiceId and deleteByInvoiceId', () async {
      final InvoiceItemRepository repository = FakeInvoiceItemRepository();
      final item = InvoiceItem(
        id: 'item-1',
        invoiceId: 'inv-1',
        description: 'Som',
        quantity: 1,
        unitPriceCents: 1000,
        totalPriceCents: 1000,
      );

      await repository.insert(item);
      expect(await repository.listByInvoiceId('inv-1'), [item]);
      await repository.deleteByInvoiceId('inv-1');
      expect(await repository.listByInvoiceId('inv-1'), isEmpty);
    });
  });
}
