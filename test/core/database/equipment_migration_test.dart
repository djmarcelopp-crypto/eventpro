// TASK-028 CP-B — testa a migração real de schema v4 -> v5 contra um banco
// SQLite genuíno, criado a partir do schema congelado em
// test/core/database/legacy_schema/ (fotografia real do schema da TASK-027).
//
// Fluxo: grava dados usando o schema legado (v4) -> fecha -> reabre o MESMO
// arquivo com o AppDatabase atual (v5) -> onUpgrade cria
// `equipment_categories` e `equipment` -> valida que nenhum dado anterior
// foi perdido.
import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v1.dart' as v1;
import 'legacy_schema/legacy_app_database_v4.dart';

void main() {
  group('schema migration v4 -> v5 (EquipmentCategories, Equipments)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'eventpro_equipment_migration_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v4 database creates equipment tables and preserves existing data',
      () async {
        final legacy = LegacyAppDatabaseV4.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyClients,
            LegacyClientsCompanion.insert(
              id: 'client-v4',
              createdAt: 1_700_000_000_000,
              type: 'individual',
              name: 'Cliente v4',
            ),
          );
          batch.insert(
            legacy.legacyCompanyProfiles,
            LegacyCompanyProfilesCompanion.insert(
              id: 'company-v4',
              tradeName: 'EventPro v4',
              defaultValidityDays: 15,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v4',
              number: 'ORC-2026-0001',
              status: 'approved',
              subtotalCents: 10_000,
              discountCents: 0,
              freightCents: 0,
              totalCents: 10_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyAgendaBlocks,
            LegacyAgendaBlocksCompanion.insert(
              id: 'block-v4',
              title: 'Bloqueio v4',
              start: 1_700_000_000_000,
              end: 1_700_010_000_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyFinancialCategories,
            LegacyFinancialCategoriesCompanion.insert(
              id: 'fin-cat-v4',
              name: 'Eventos',
              kind: 'income',
              active: true,
              createdAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyFinancialEntries,
            LegacyFinancialEntriesCompanion.insert(
              id: 'fin-entry-v4',
              kind: 'income',
              description: 'Sinal',
              amountCents: 50_000,
              date: '2026-07-01',
              categoryId: 'fin-cat-v4',
              status: 'paid',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
        });
        expect(legacy.schemaVersion, 4);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(upgraded.schemaVersion, 7);

        final clients = await upgraded.select(upgraded.clients).get();
        expect(clients.single.id, 'client-v4');

        final quotes = await upgraded.select(upgraded.quotes).get();
        expect(quotes.single.id, 'quote-v4');

        final blocks = await upgraded.select(upgraded.agendaBlocks).get();
        expect(blocks.single.id, 'block-v4');

        final finCats =
            await upgraded.select(upgraded.financialCategories).get();
        expect(finCats.single.id, 'fin-cat-v4');

        final finEntries =
            await upgraded.select(upgraded.financialEntries).get();
        expect(finEntries.single.id, 'fin-entry-v4');

        final categories =
            await upgraded.select(upgraded.equipmentCategories).get();
        expect(categories, isEmpty);

        final equipment = await upgraded.select(upgraded.equipments).get();
        expect(equipment, isEmpty);

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');

        await upgraded.into(upgraded.equipmentCategories).insert(
              EquipmentCategoriesCompanion.insert(
                id: 'eq-cat-1',
                name: 'Som',
                active: true,
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );
        await upgraded.into(upgraded.equipments).insert(
              EquipmentsCompanion.insert(
                id: 'eq-1',
                name: 'Caixa',
                description: 'JBL',
                categoryId: 'eq-cat-1',
                totalQuantity: 2,
                status: 'available',
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );

        final inserted =
            await upgraded.select(upgraded.equipments).getSingle();
        expect(inserted.name, 'Caixa');
        expect(inserted.categoryId, 'eq-cat-1');
      },
    );

    test(
      'jumping from v1 to v5 creates agenda, financial and equipment tables',
      () async {
        final legacy = v1.LegacyAppDatabaseV1.forTesting(dbFile);
        await legacy.into(legacy.legacyClients).insert(
              v1.LegacyClientsCompanion.insert(
                id: 'client-v1',
                createdAt: 1_700_000_000_000,
                type: 'individual',
                name: 'Cliente v1',
              ),
            );
        expect(legacy.schemaVersion, 1);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(upgraded.schemaVersion, 7);

        final clients = await upgraded.select(upgraded.clients).get();
        expect(clients.single.id, 'client-v1');

        final blocks = await upgraded.select(upgraded.agendaBlocks).get();
        expect(blocks, isEmpty);

        final finCats =
            await upgraded.select(upgraded.financialCategories).get();
        expect(finCats, isEmpty);

        final categories =
            await upgraded.select(upgraded.equipmentCategories).get();
        expect(categories, isEmpty);

        final equipment = await upgraded.select(upgraded.equipments).get();
        expect(equipment, isEmpty);
      },
    );
  });
}
