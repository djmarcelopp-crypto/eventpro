// TASK-032 CP-B — migração real schema v11 -> v12 (invoices / invoice_items).
import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v11.dart';

void main() {
  group('schema migration v11 -> v12 (Invoices, InvoiceItems)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'eventpro_invoice_migration_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v11 database creates invoice tables and preserves data',
      () async {
        final legacy = LegacyAppDatabaseV11.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v11',
              number: 'ORC-2026-0001',
              status: 'draft',
              subtotalCents: 0,
              discountCents: 0,
              freightCents: 0,
              totalCents: 0,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyContractTemplates,
            LegacyContractTemplatesCompanion.insert(
              id: 'tpl-v11',
              name: 'Padrão',
              active: true,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyContracts,
            LegacyContractsCompanion.insert(
              id: 'ctr-v11',
              quoteId: 'quote-v11',
              contractNumber: 'CTR-2026-0001',
              status: 'draft',
              notes: '',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
        });
        expect(legacy.schemaVersion, 11);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(upgraded.schemaVersion, 12);
        expect(
          (await upgraded.select(upgraded.quotes).get()).single.id,
          'quote-v11',
        );
        expect(
          (await upgraded.select(upgraded.contracts).get()).single.id,
          'ctr-v11',
        );
        expect(await upgraded.select(upgraded.invoices).get(), isEmpty);
        expect(await upgraded.select(upgraded.invoiceItems).get(), isEmpty);

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');

        await upgraded.into(upgraded.invoices).insert(
              InvoicesCompanion.insert(
                id: 'inv-1',
                quoteId: 'quote-v11',
                invoiceNumber: 'INV-2026-0001',
                type: 'service',
                status: 'draft',
                subtotalCents: 1000,
                taxCents: 0,
                discountCents: 0,
                totalCents: 1000,
                notes: '',
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );
        await upgraded.into(upgraded.invoiceItems).insert(
              InvoiceItemsCompanion.insert(
                id: 'item-1',
                invoiceId: 'inv-1',
                description: 'Som',
                quantity: 1,
                unitPriceCents: 1000,
                totalPriceCents: 1000,
              ),
            );
        expect(
          (await upgraded.select(upgraded.invoiceItems).get()).single.id,
          'item-1',
        );
      },
    );
  });
}
