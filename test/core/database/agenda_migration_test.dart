// TASK-025 CP-A — testa a migração real de schema v1 -> v2 contra um banco
// SQLite genuíno, criado a partir do schema congelado em
// test/core/database/legacy_schema/ (fotografia real do schema da TASK-024).
//
// Fluxo: grava dados usando o schema legado (v1) -> fecha -> reabre o MESMO
// arquivo com o AppDatabase atual (v2) -> onUpgrade cria `agenda_blocks` ->
// valida que nenhum dado anterior foi perdido ou alterado.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'legacy_schema/legacy_app_database_v1.dart';

void main() {
  group('schema migration v1 -> v2 (AgendaBlocks)', () {
    late Directory tempDir;
    late File dbFile;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('eventpro_migration_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test(
      'upgrading a genuine v1 database creates agenda_blocks and preserves all existing data',
      () async {
        final legacy = LegacyAppDatabaseV1.forTesting(dbFile);
        await legacy.batch((batch) {
          batch.insert(
            legacy.legacyClients,
            LegacyClientsCompanion.insert(
              id: 'client-v1',
              createdAt: 1_700_000_000_000,
              type: 'individual',
              name: 'Cliente Legado',
            ),
          );
          batch.insertAll(legacy.legacyCatalogItems, [
            LegacyCatalogItemsCompanion.insert(
              id: 'package-v1',
              createdAt: 1_700_000_000_000,
              type: 'package',
              name: 'Pacote Legado',
              category: 'sound',
              unit: 'pacote',
              priceCents: 10_000,
              active: true,
            ),
            LegacyCatalogItemsCompanion.insert(
              id: 'component-v1',
              createdAt: 1_700_000_000_000,
              type: 'equipment',
              name: 'Caixa Legada',
              category: 'sound',
              unit: 'un',
              priceCents: 2_500,
              active: true,
            ),
          ]);
          batch.insert(
            legacy.legacyCatalogPackageComponents,
            LegacyCatalogPackageComponentsCompanion.insert(
              packageId: 'package-v1',
              componentItemId: 'component-v1',
              nameSnapshot: 'Caixa Legada',
              unitSnapshot: 'un',
              typeSnapshot: 'Equipamento',
              categorySnapshot: 'Som',
              quantityPerPackage: 2,
            ),
          );
          batch.insert(
            legacy.legacyCompanyProfiles,
            LegacyCompanyProfilesCompanion.insert(
              id: 'company-v1',
              tradeName: 'EventPro Legado',
              defaultValidityDays: 15,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyQuotes,
            LegacyQuotesCompanion.insert(
              id: 'quote-v1',
              number: 'ORC-2026-0001',
              status: 'approved',
              subtotalCents: 10_000,
              discountCents: 0,
              freightCents: 0,
              totalCents: 10_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
              approvedAt: Value(1_700_000_100_000),
            ),
          );
          batch.insert(
            legacy.legacyQuoteClientSnapshots,
            LegacyQuoteClientSnapshotsCompanion.insert(
              quoteId: 'quote-v1',
              type: 'individual',
              displayName: 'Cliente Legado',
            ),
          );
          batch.insert(
            legacy.legacyQuoteEventSnapshots,
            LegacyQuoteEventSnapshotsCompanion.insert(
              quoteId: 'quote-v1',
              name: Value('Casamento Legado'),
              eventDate: const Value('2026-08-15'),
              startTime: const Value('18:00'),
              endTime: const Value('23:30'),
            ),
          );
          batch.insert(
            legacy.legacyQuoteCompanySnapshots,
            LegacyQuoteCompanySnapshotsCompanion.insert(
              quoteId: 'quote-v1',
              captureStatus: 'configured',
              capturedAt: 1_700_000_000_000,
              identTradeName: 'EventPro Legado',
            ),
          );
          batch.insert(
            legacy.legacyQuoteLineItems,
            LegacyQuoteLineItemsCompanion.insert(
              id: 'line-v1',
              quoteId: 'quote-v1',
              sortOrder: 0,
              name: 'Pacote Legado',
              unit: 'pacote',
              quantity: 1,
              unitPriceCents: 10_000,
              lineTotalCents: 10_000,
            ),
          );
          batch.insert(
            legacy.legacyQuoteLinePackageComponents,
            LegacyQuoteLinePackageComponentsCompanion.insert(
              id: 'pkg-line-v1',
              lineItemId: 'line-v1',
              sortOrder: 0,
              name: 'Caixa Legada',
              unit: 'un',
              typeLabel: 'Equipamento',
              categoryLabel: 'Som',
              quantityPerPackage: 2,
            ),
          );
          batch.insert(
            legacy.legacyQuoteStatusHistory,
            LegacyQuoteStatusHistoryCompanion.insert(
              id: 'history-v1',
              quoteId: 'quote-v1',
              sortOrder: 0,
              newStatus: 'draft',
              changedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            legacy.legacyQuoteNumberSequences,
            LegacyQuoteNumberSequencesCompanion.insert(
              year: const Value(2026),
              lastSequence: 1,
            ),
          );
        });
        expect(legacy.schemaVersion, 1);
        await legacy.close();

        final upgraded = AppDatabase.forTesting(dbFile);
        addTearDown(upgraded.close);

        // TASK-027 CP-B/CP-D bumped schemaVersion to 4; a genuine v1
        // database now jumps directly to v4, creating agenda_blocks (this
        // migration) and the financial tables + quoteId link (see
        // financial_migration_test.dart and
        // financial_entry_quote_link_migration_test.dart) together.
        expect(upgraded.schemaVersion, 11);

        final tableNames = await upgraded
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'agenda_blocks'",
            )
            .get();
        expect(tableNames, hasLength(1));
        expect(await upgraded.select(upgraded.agendaBlocks).get(), isEmpty);

        expect(await upgraded.select(upgraded.clients).get(), hasLength(1));
        final client = await upgraded.select(upgraded.clients).getSingle();
        expect(client.id, 'client-v1');
        expect(client.name, 'Cliente Legado');

        expect(
          await upgraded.select(upgraded.catalogItems).get(),
          hasLength(2),
        );
        expect(
          await upgraded.select(upgraded.catalogPackageComponents).get(),
          hasLength(1),
        );

        expect(
          await upgraded.select(upgraded.companyProfiles).get(),
          hasLength(1),
        );

        expect(await upgraded.select(upgraded.quotes).get(), hasLength(1));
        final quote = await upgraded.select(upgraded.quotes).getSingle();
        expect(quote.id, 'quote-v1');
        expect(quote.number, 'ORC-2026-0001');
        expect(quote.status, 'approved');
        expect(quote.totalCents, 10_000);

        expect(
          await upgraded.select(upgraded.quoteClientSnapshots).get(),
          hasLength(1),
        );
        final eventSnapshot = await upgraded
            .select(upgraded.quoteEventSnapshots)
            .getSingle();
        expect(eventSnapshot.name, 'Casamento Legado');
        expect(eventSnapshot.eventDate, '2026-08-15');
        expect(eventSnapshot.startTime, '18:00');
        expect(eventSnapshot.endTime, '23:30');

        expect(
          await upgraded.select(upgraded.quoteCompanySnapshots).get(),
          hasLength(1),
        );
        expect(
          await upgraded.select(upgraded.quoteLineItems).get(),
          hasLength(1),
        );
        expect(
          await upgraded.select(upgraded.quoteLinePackageComponents).get(),
          hasLength(1),
        );
        expect(
          await upgraded.select(upgraded.quoteStatusHistory).get(),
          hasLength(1),
        );

        final sequence = await upgraded
            .select(upgraded.quoteNumberSequences)
            .getSingle();
        expect(sequence.year, 2026);
        expect(sequence.lastSequence, 1);

        final integrity = await upgraded
            .customSelect('PRAGMA integrity_check')
            .getSingle();
        expect(integrity.data.values.single, 'ok');

        await upgraded
            .into(upgraded.agendaBlocks)
            .insert(
              AgendaBlocksCompanion.insert(
                id: 'block-post-migration',
                title: 'Bloqueio pós-migração',
                start: 1_700_100_000_000,
                end: 1_700_110_000_000,
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );
        expect(
          await upgraded.select(upgraded.agendaBlocks).get(),
          hasLength(1),
        );
      },
    );
  });
}
