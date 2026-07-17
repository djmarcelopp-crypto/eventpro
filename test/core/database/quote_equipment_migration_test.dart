// TASK-028 CP-D — migração real schema v5 -> v6 (tabela quote_equipment).
import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v5.dart';

void main() {
  group('schema migration v5 -> v6 (QuoteEquipmentItems)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'eventpro_quote_equipment_migration_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v5 database creates quote_equipment and preserves data',
      () async {
        final legacy = LegacyAppDatabaseV5.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v5',
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
            legacy.legacyEquipmentCategories,
            LegacyEquipmentCategoriesCompanion.insert(
              id: 'eq-cat-v5',
              name: 'Som',
              active: true,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyEquipments,
            LegacyEquipmentsCompanion.insert(
              id: 'eq-v5',
              name: 'Caixa',
              description: '',
              categoryId: 'eq-cat-v5',
              totalQuantity: 2,
              status: 'available',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
        });
        expect(legacy.schemaVersion, 5);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(upgraded.schemaVersion, 6);

        final quotes = await upgraded.select(upgraded.quotes).get();
        expect(quotes.single.id, 'quote-v5');

        final equipment = await upgraded.select(upgraded.equipments).get();
        expect(equipment.single.id, 'eq-v5');
        expect(equipment.single.status, 'available');

        final links =
            await upgraded.select(upgraded.quoteEquipmentItems).get();
        expect(links, isEmpty);

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');

        await upgraded.into(upgraded.quoteEquipmentItems).insert(
              QuoteEquipmentItemsCompanion.insert(
                id: 'link-1',
                quoteId: 'quote-v5',
                equipmentId: 'eq-v5',
                quantity: 2,
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );

        expect(
          (await upgraded.select(upgraded.quoteEquipmentItems).getSingle())
              .quantity,
          2,
        );

        // Equipment status untouched by the link insert.
        expect(
          (await upgraded.select(upgraded.equipments).getSingle()).status,
          'available',
        );
      },
    );
  });
}
