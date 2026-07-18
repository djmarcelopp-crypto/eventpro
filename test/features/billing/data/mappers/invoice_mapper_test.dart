import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/billing/data/mappers/invoice_item_mapper.dart';
import 'package:eventpro/features/billing/data/mappers/invoice_mapper.dart';
import 'package:eventpro/features/billing/models/invoice.dart';
import 'package:eventpro/features/billing/models/invoice_item.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceMapper / InvoiceItemMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    final now = DateTime(2026, 7, 17, 12);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('invoice_mapper_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
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

    test('round-trips invoice and item fields', () async {
      final invoice = Invoice(
        id: 'inv-1',
        quoteId: 'quote-1',
        invoiceNumber: 'INV-1',
        type: InvoiceType.mixed,
        status: InvoiceStatus.issued,
        issueDate: now,
        subtotalCents: 2000,
        taxCents: 200,
        discountCents: 100,
        totalCents: 2100,
        notes: 'nota',
        createdAt: now,
        updatedAt: now,
      );
      await database.into(database.invoices).insert(
            InvoiceMapper.toInsertCompanion(invoice),
          );
      final invoiceRow = await (database.select(database.invoices)
            ..where((tbl) => tbl.id.equals('inv-1')))
          .getSingle();
      expect(InvoiceMapper.toDomain(invoiceRow), invoice);

      final item = InvoiceItem(
        id: 'item-1',
        invoiceId: 'inv-1',
        description: 'Som',
        quantity: 1.5,
        unitPriceCents: 1000,
        totalPriceCents: 1500,
      );
      await database.into(database.invoiceItems).insert(
            InvoiceItemMapper.toInsertCompanion(item),
          );
      final itemRow = await (database.select(database.invoiceItems)
            ..where((tbl) => tbl.id.equals('item-1')))
          .getSingle();
      expect(InvoiceItemMapper.toDomain(itemRow), item);
    });
  });
}
