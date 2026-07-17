// TASK-027 CP-B — testa a migração real de schema v2 -> v3 contra um banco
// SQLite genuíno, criado a partir do schema congelado em
// test/core/database/legacy_schema/ (fotografia real do schema da TASK-025).
//
// Fluxo: grava dados usando o schema legado (v2, com agenda_blocks) -> fecha
// -> reabre o MESMO arquivo com o AppDatabase atual (hoje na v4, ver
// financial_entry_quote_link_migration_test.dart para o CP-D) -> onUpgrade
// cria `financial_categories` e `financial_entries` -> valida que nenhum
// dado anterior foi perdido ou alterado.
//
// Também testa o salto direto v1 -> v4 (usuário que nunca abriu a versão
// v2), reutilizando o snapshot v1 já existente da TASK-025 CP-A, para
// garantir que `agenda_blocks`, as tabelas financeiras e o vínculo
// `quoteId` são criados juntos em uma única migração.
import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v1.dart' as v1;
import 'legacy_schema/legacy_app_database_v2.dart';

void main() {
  group('schema migration v2 -> v3 (FinancialCategories, FinancialEntries)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'eventpro_financial_migration_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v2 database creates the financial tables and preserves all existing data',
      () async {
        final legacy = LegacyAppDatabaseV2.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyClients,
            LegacyClientsCompanion.insert(
              id: 'client-v2',
              createdAt: 1_700_000_000_000,
              type: 'individual',
              name: 'Cliente v2',
            ),
          );
          batch.insert(
            legacy.legacyCompanyProfiles,
            LegacyCompanyProfilesCompanion.insert(
              id: 'company-v2',
              tradeName: 'EventPro v2',
              defaultValidityDays: 15,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v2',
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
              id: 'block-v2',
              title: 'Bloqueio v2',
              start: 1_700_000_000_000,
              end: 1_700_010_000_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
        });
        expect(legacy.schemaVersion, 2);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        // AppDatabase is now at v5 (TASK-028 CP-B); a v2 database upgrades
        // through v3 (financial), v4 (quoteId) and v5 (equipment tables).
        expect(upgraded.schemaVersion, 6);

        final tableNames = await upgraded
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type = 'table' AND "
              "name IN ('financial_categories', 'financial_entries')",
            )
            .get();
        expect(tableNames, hasLength(2));
        expect(
          await upgraded.select(upgraded.financialCategories).get(),
          isEmpty,
        );
        expect(
          await upgraded.select(upgraded.financialEntries).get(),
          isEmpty,
        );

        expect(await upgraded.select(upgraded.clients).get(), hasLength(1));
        final client = await upgraded.select(upgraded.clients).getSingle();
        expect(client.id, 'client-v2');

        expect(
          await upgraded.select(upgraded.companyProfiles).get(),
          hasLength(1),
        );

        expect(await upgraded.select(upgraded.quotes).get(), hasLength(1));
        final quote = await upgraded.select(upgraded.quotes).getSingle();
        expect(quote.id, 'quote-v2');
        expect(quote.number, 'ORC-2026-0001');

        expect(
          await upgraded.select(upgraded.agendaBlocks).get(),
          hasLength(1),
        );
        final block = await upgraded.select(upgraded.agendaBlocks).getSingle();
        expect(block.id, 'block-v2');
        expect(block.title, 'Bloqueio v2');

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');

        await upgraded
            .into(upgraded.financialCategories)
            .insert(
              FinancialCategoriesCompanion.insert(
                id: 'category-post-migration',
                name: 'Categoria pós-migração',
                kind: 'expense',
                active: true,
                createdAt: 1_700_000_000_000,
              ),
            );
        await upgraded
            .into(upgraded.financialEntries)
            .insert(
              FinancialEntriesCompanion.insert(
                id: 'entry-post-migration',
                kind: 'expense',
                description: 'Lançamento pós-migração',
                amountCents: 5_000,
                date: '2026-08-05',
                categoryId: 'category-post-migration',
                status: 'pending',
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );
        expect(
          await upgraded.select(upgraded.financialCategories).get(),
          hasLength(1),
        );
        expect(
          await upgraded.select(upgraded.financialEntries).get(),
          hasLength(1),
        );
      },
    );

    test(
      'upgrading a genuine v1 database (never opened as v2) creates both agenda_blocks and the financial tables in a single jump',
      () async {
        final legacy = v1.LegacyAppDatabaseV1.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyClients,
            v1.LegacyClientsCompanion.insert(
              id: 'client-v1',
              createdAt: 1_700_000_000_000,
              type: 'individual',
              name: 'Cliente v1',
            ),
          );
        });
        expect(legacy.schemaVersion, 1);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        // Direct v1 -> v5 jump: agenda_blocks, financial tables, quoteId and
        // equipment tables are all created across onUpgrade steps.
        expect(upgraded.schemaVersion, 6);

        expect(await upgraded.select(upgraded.clients).get(), hasLength(1));
        expect(
          await upgraded.select(upgraded.agendaBlocks).get(),
          isEmpty,
        );
        expect(
          await upgraded.select(upgraded.financialCategories).get(),
          isEmpty,
        );
        expect(
          await upgraded.select(upgraded.financialEntries).get(),
          isEmpty,
        );

        final tableNames = await upgraded
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type = 'table' AND "
              "name IN ('agenda_blocks', 'financial_categories', 'financial_entries')",
            )
            .get();
        expect(tableNames, hasLength(3));

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');
      },
    );
  });
}
