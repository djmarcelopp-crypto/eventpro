import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/billing/data/repositories/drift_invoice_item_repository.dart';
import 'package:eventpro/features/billing/data/repositories/drift_invoice_repository.dart';
import 'package:eventpro/features/billing/models/invoice.dart';
import 'package:eventpro/features/billing/models/invoice_item.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftInvoice*Repository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftInvoiceRepository invoiceRepository;
    late DriftInvoiceItemRepository itemRepository;
    final now = DateTime(2026, 7, 17, 12);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('invoice_repo_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      invoiceRepository = DriftInvoiceRepository(database);
      itemRepository = DriftInvoiceItemRepository(database);
      await database.into(database.quotes).insert(
            QuotesCompanion.insert(
              id: 'quote-1',
              number: 'ORC-1',
              status: 'draft',
              subtotalCents: 0,
              discountCents: 0,
              freightCents: 0,
              totalCents: 0,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('persists invoices and cascaded items', () async {
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
      await invoiceRepository.insert(invoice);
      expect(await invoiceRepository.listByQuoteId('quote-1'), [invoice]);

      final item = InvoiceItem(
        id: 'item-1',
        invoiceId: 'inv-1',
        description: 'Som',
        quantity: 2,
        unitPriceCents: 500,
        totalPriceCents: 1000,
      );
      await itemRepository.insert(item);
      expect(await itemRepository.listByInvoiceId('inv-1'), [item]);

      await invoiceRepository.delete('inv-1');
      expect(await invoiceRepository.listAll(), isEmpty);
      expect(await itemRepository.listByInvoiceId('inv-1'), isEmpty);
    });
  });
}
