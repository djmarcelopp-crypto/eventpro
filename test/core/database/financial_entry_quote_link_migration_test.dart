// TASK-027 CP-D — testa a migração real de schema v3 -> v4 contra um banco
// SQLite genuíno, criado a partir do schema congelado em
// test/core/database/legacy_schema/legacy_tables_v3.dart (fotografia real
// do schema pós TASK-027 CP-B/CP-C, antes de `financial_entries.quoteId`
// existir).
//
// Fluxo: grava dados usando o schema legado (v3, com financial_categories e
// financial_entries, mas sem quoteId) -> fecha -> reabre o MESMO arquivo com
// o AppDatabase atual (v4) -> onUpgrade adiciona a coluna `quoteId` -> valida
// que nenhum dado anterior foi perdido e que os lançamentos existentes ficam
// com `quoteId = NULL` (nenhum evento associado).
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v3.dart';

void main() {
  group('schema migration v3 -> v4 (financial_entries.quoteId)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'eventpro_financial_quote_link_migration_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v3 database adds a nullable quoteId column and preserves all existing data',
      () async {
        final legacy = LegacyAppDatabaseV3.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v3',
              number: 'ORC-2026-0001',
              status: 'approved',
              subtotalCents: 50_000,
              discountCents: 0,
              freightCents: 0,
              totalCents: 50_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyFinancialCategories,
            LegacyFinancialCategoriesCompanion.insert(
              id: 'category-v3',
              name: 'Locação de espaço',
              kind: 'expense',
              active: true,
              createdAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyFinancialEntries,
            LegacyFinancialEntriesCompanion.insert(
              id: 'entry-v3',
              kind: 'expense',
              description: 'Aluguel do salão',
              amountCents: 30_000,
              date: '2026-08-05',
              categoryId: 'category-v3',
              status: 'pending',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
        });
        expect(legacy.schemaVersion, 3);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(upgraded.schemaVersion, 10);

        final columnNames = await upgraded
            .customSelect('PRAGMA table_info(financial_entries)')
            .get();
        expect(
          columnNames.map((row) => row.data['name']),
          contains('quote_id'),
        );

        expect(await upgraded.select(upgraded.quotes).get(), hasLength(1));
        expect(
          await upgraded.select(upgraded.financialCategories).get(),
          hasLength(1),
        );

        final entries = await upgraded.select(upgraded.financialEntries).get();
        expect(entries, hasLength(1));
        final entry = entries.single;
        expect(entry.id, 'entry-v3');
        expect(entry.description, 'Aluguel do salão');
        expect(entry.amountCents, 30_000);
        expect(
          entry.quoteId,
          isNull,
          reason: 'pre-existing entries have no event association after '
              'the migration',
        );

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');
      },
    );

    test(
      'idx_financial_entries_quote_id index is created by the migration',
      () async {
        final legacy = LegacyAppDatabaseV3.forTesting(dbFile);
        expect(legacy.schemaVersion, 3);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        final indexNames = await upgraded
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type = 'index' AND "
              "name = 'idx_financial_entries_quote_id'",
            )
            .get();
        expect(indexNames, hasLength(1));
      },
    );

    test(
      'a new entry can be linked to an existing quote after the migration',
      () async {
        final legacy = LegacyAppDatabaseV3.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v3',
              number: 'ORC-2026-0001',
              status: 'approved',
              subtotalCents: 50_000,
              discountCents: 0,
              freightCents: 0,
              totalCents: 50_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyFinancialCategories,
            LegacyFinancialCategoriesCompanion.insert(
              id: 'category-v3',
              name: 'Locação de espaço',
              kind: 'expense',
              active: true,
              createdAt: 1_700_000_000_000,
            ),
          );
        });
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        await upgraded
            .into(upgraded.financialEntries)
            .insert(
              FinancialEntriesCompanion.insert(
                id: 'entry-post-migration',
                kind: 'expense',
                description: 'Buffet do evento',
                amountCents: 20_000,
                date: '2026-08-06',
                categoryId: 'category-v3',
                status: 'pending',
                quoteId: const Value('quote-v3'),
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );

        final linked =
            await (upgraded.select(upgraded.financialEntries)
                  ..where((row) => row.quoteId.equals('quote-v3')))
                .get();
        expect(linked, hasLength(1));
        expect(linked.single.id, 'entry-post-migration');
      },
    );

    test(
      'inserting an entry with an unknown quoteId violates the foreign key constraint',
      () async {
        final legacy = LegacyAppDatabaseV3.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyFinancialCategories,
            LegacyFinancialCategoriesCompanion.insert(
              id: 'category-v3',
              name: 'Locação de espaço',
              kind: 'expense',
              active: true,
              createdAt: 1_700_000_000_000,
            ),
          );
        });
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        expect(
          () => upgraded
              .into(upgraded.financialEntries)
              .insert(
                FinancialEntriesCompanion.insert(
                  id: 'entry-dangling',
                  kind: 'expense',
                  description: 'Item sem evento válido',
                  amountCents: 1_000,
                  date: '2026-08-06',
                  categoryId: 'category-v3',
                  status: 'pending',
                  quoteId: const Value('missing-quote'),
                  createdAt: 1_700_000_000_000,
                  updatedAt: 1_700_000_000_000,
                ),
              ),
          throwsA(anything),
        );
      },
    );
  });
}
