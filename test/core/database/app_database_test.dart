import 'dart:io';

import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

bool _isUniqueConstraintViolation(Object error) {
  return error.toString().contains('UNIQUE constraint failed');
}

bool _isForeignKeyConstraintViolation(Object error) {
  return error.toString().contains('FOREIGN KEY constraint failed');
}

void main() {
  group('file lifecycle', () {
    test('opens and closes a temporary database file on disk', () async {
      final isolatedDir = await Directory.systemTemp.createTemp(
        'eventpro_isolated_',
      );
      addTearDown(() async {
        if (await isolatedDir.exists()) {
          await isolatedDir.delete(recursive: true);
        }
      });

      final isolatedFile = File('${isolatedDir.path}/eventpro.sqlite');
      expect(await isolatedFile.exists(), isFalse);

      final db = AppDatabase.forTesting(isolatedFile);

      await db
          .into(db.clients)
          .insert(
            ClientsCompanion.insert(
              id: 'client-1',
              createdAt: 1_700_000_000_000,
              type: 'individual',
              name: 'Cliente Teste',
            ),
          );

      await db.close();
      expect(await isolatedFile.exists(), isTrue);

      final reopened = AppDatabase.forTesting(isolatedFile);
      addTearDown(reopened.close);

      final rows = await reopened.select(reopened.clients).get();
      expect(rows, hasLength(1));
      expect(rows.single.id, 'client-1');
    });
  });

  group('schema and constraints', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('eventpro_db_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('schemaVersion is 7', () {
      expect(database.schemaVersion, 7);
    });

    test('foreign key enforcement is enabled by beforeOpen', () async {
      expect(await isForeignKeyEnforcementEnabled(database), isTrue);

      await expectLater(
        database
            .into(database.quoteClientSnapshots)
            .insert(
              QuoteClientSnapshotsCompanion.insert(
                quoteId: 'missing-quote',
                type: 'individual',
                displayName: 'Cliente',
              ),
            ),
        throwsA(predicate(_isForeignKeyConstraintViolation, 'foreign key')),
      );
    });

    test('quote number UNIQUE constraint rejects duplicates', () async {
      await _insertQuote(database, id: 'quote-1', number: 'ORC-2026-0001');

      await expectLater(
        _insertQuote(database, id: 'quote-2', number: 'ORC-2026-0001'),
        throwsA(predicate(_isUniqueConstraintViolation, 'unique constraint')),
      );
    });

    test('deleting quote cascades to child tables', () async {
      await _insertQuoteGraph(database, quoteId: 'quote-cascade');

      await (database.delete(
        database.quotes,
      )..where((tbl) => tbl.id.equals('quote-cascade'))).go();

      expect(
        await database.select(database.quoteClientSnapshots).get(),
        isEmpty,
      );
      expect(
        await database.select(database.quoteEventSnapshots).get(),
        isEmpty,
      );
      expect(
        await database.select(database.quoteCompanySnapshots).get(),
        isEmpty,
      );
      expect(await database.select(database.quoteLineItems).get(), isEmpty);
      expect(
        await database.select(database.quoteLinePackageComponents).get(),
        isEmpty,
      );
      expect(await database.select(database.quoteStatusHistory).get(), isEmpty);
    });

    test('deleting package cascades to catalog package components', () async {
      await database.batch((batch) {
        batch.insertAll(database.catalogItems, [
          CatalogItemsCompanion.insert(
            id: 'package-1',
            createdAt: 1,
            type: 'package',
            name: 'Pacote Som',
            category: 'sound',
            unit: 'pacote',
            priceCents: 10_000,
            active: true,
          ),
          CatalogItemsCompanion.insert(
            id: 'component-1',
            createdAt: 1,
            type: 'equipment',
            name: 'Caixa',
            category: 'sound',
            unit: 'un',
            priceCents: 2_500,
            active: true,
          ),
        ]);
        batch.insert(
          database.catalogPackageComponents,
          CatalogPackageComponentsCompanion.insert(
            packageId: 'package-1',
            componentItemId: 'component-1',
            nameSnapshot: 'Caixa',
            unitSnapshot: 'un',
            typeSnapshot: 'Equipamento',
            categorySnapshot: 'Som',
            quantityPerPackage: 2,
          ),
        );
      });

      await (database.delete(
        database.catalogItems,
      )..where((tbl) => tbl.id.equals('package-1'))).go();

      expect(
        await database.select(database.catalogPackageComponents).get(),
        isEmpty,
      );
      expect(await database.select(database.catalogItems).get(), hasLength(1));
    });

    test('deleting component referenced by package is restricted', () async {
      await database.batch((batch) {
        batch.insertAll(database.catalogItems, [
          CatalogItemsCompanion.insert(
            id: 'package-2',
            createdAt: 1,
            type: 'package',
            name: 'Pacote Luz',
            category: 'lighting',
            unit: 'pacote',
            priceCents: 8_000,
            active: true,
          ),
          CatalogItemsCompanion.insert(
            id: 'component-2',
            createdAt: 1,
            type: 'service',
            name: 'Operador',
            category: 'team',
            unit: 'un',
            priceCents: 1_500,
            active: true,
          ),
        ]);
        batch.insert(
          database.catalogPackageComponents,
          CatalogPackageComponentsCompanion.insert(
            packageId: 'package-2',
            componentItemId: 'component-2',
            nameSnapshot: 'Operador',
            unitSnapshot: 'un',
            typeSnapshot: 'Serviço',
            categorySnapshot: 'Equipe',
            quantityPerPackage: 1,
          ),
        );
      });

      await expectLater(
        (database.delete(
          database.catalogItems,
        )..where((tbl) => tbl.id.equals('component-2'))).go(),
        throwsA(predicate(_isForeignKeyConstraintViolation, 'foreign key')),
      );
    });

    test('money values round-trip as integer cents without loss', () async {
      const expectedCents = 12_345;

      await database
          .into(database.catalogItems)
          .insert(
            CatalogItemsCompanion.insert(
              id: 'money-item',
              createdAt: 1,
              type: 'equipment',
              name: 'Mixer',
              category: 'sound',
              unit: 'un',
              priceCents: expectedCents,
              active: true,
            ),
          );

      final row = await (database.select(
        database.catalogItems,
      )..where((tbl) => tbl.id.equals('money-item'))).getSingle();

      expect(row.priceCents, expectedCents);
      expect(row.priceCents, isA<int>());
    });

    test('catalog item active column round-trips as bool', () async {
      await database
          .into(database.catalogItems)
          .insert(
            CatalogItemsCompanion.insert(
              id: 'bool-item',
              createdAt: 1,
              type: 'service',
              name: 'DJ',
              category: 'dj',
              unit: 'hora',
              priceCents: 500_00,
              active: false,
            ),
          );

      final row = await (database.select(
        database.catalogItems,
      )..where((tbl) => tbl.id.equals('bool-item'))).getSingle();

      expect(row.active, isFalse);
      expect(row.active, isA<bool>());
    });

    test('civil dates are preserved without timezone conversion', () async {
      const birthday = '1990-07-15';

      await database
          .into(database.clients)
          .insert(
            ClientsCompanion.insert(
              id: 'client-date',
              createdAt: 1_700_000_000_000,
              type: 'individual',
              name: 'Aniversariante',
              birthday: Value(birthday),
            ),
          );

      final client = await (database.select(
        database.clients,
      )..where((tbl) => tbl.id.equals('client-date'))).getSingle();
      expect(client.birthday, birthday);

      await _insertQuote(
        database,
        id: 'quote-date',
        number: 'ORC-2026-0099',
        validUntil: birthday,
      );

      final quote = await (database.select(
        database.quotes,
      )..where((tbl) => tbl.id.equals('quote-date'))).getSingle();
      expect(quote.validUntil, birthday);

      await database
          .into(database.quoteEventSnapshots)
          .insert(
            QuoteEventSnapshotsCompanion.insert(
              quoteId: 'quote-date',
              eventDate: Value(birthday),
            ),
          );

      final event = await (database.select(
        database.quoteEventSnapshots,
      )..where((tbl) => tbl.quoteId.equals('quote-date'))).getSingle();
      expect(event.eventDate, birthday);
    });

    test(
      'duplicate package+component pair rejects composite primary key',
      () async {
        await database.batch((batch) {
          batch.insertAll(database.catalogItems, [
            CatalogItemsCompanion.insert(
              id: 'package-pk',
              createdAt: 1,
              type: 'package',
              name: 'Pacote PK',
              category: 'sound',
              unit: 'pacote',
              priceCents: 10_000,
              active: true,
            ),
            CatalogItemsCompanion.insert(
              id: 'component-pk',
              createdAt: 1,
              type: 'equipment',
              name: 'Caixa PK',
              category: 'sound',
              unit: 'un',
              priceCents: 2_500,
              active: true,
            ),
          ]);
          batch.insert(
            database.catalogPackageComponents,
            CatalogPackageComponentsCompanion.insert(
              packageId: 'package-pk',
              componentItemId: 'component-pk',
              nameSnapshot: 'Caixa PK',
              unitSnapshot: 'un',
              typeSnapshot: 'Equipamento',
              categorySnapshot: 'Som',
              quantityPerPackage: 1,
            ),
          );
        });

        await expectLater(
          database
              .into(database.catalogPackageComponents)
              .insert(
                CatalogPackageComponentsCompanion.insert(
                  packageId: 'package-pk',
                  componentItemId: 'component-pk',
                  nameSnapshot: 'Caixa PK duplicada',
                  unitSnapshot: 'un',
                  typeSnapshot: 'Equipamento',
                  categorySnapshot: 'Som',
                  quantityPerPackage: 3,
                ),
              ),
          throwsA(predicate(_isUniqueConstraintViolation, 'unique constraint')),
        );
      },
    );

    test(
      'deleting a quote line item cascades to its package components',
      () async {
        await _insertQuoteGraph(database, quoteId: 'quote-line-cascade');

        await (database.delete(
          database.quoteLineItems,
        )..where((tbl) => tbl.id.equals('line-1'))).go();

        expect(
          await database.select(database.quoteLinePackageComponents).get(),
          isEmpty,
        );
        expect(await database.select(database.quoteLineItems).get(), isEmpty);
      },
    );

    test(
      'reopening the database file preserves a full quote graph',
      () async {
        await database.close();

        final freshDir = await Directory.systemTemp.createTemp(
          'eventpro_graph_reopen_',
        );
        addTearDown(() async {
          if (await freshDir.exists()) {
            await freshDir.delete(recursive: true);
          }
        });

        final graphFile = File('${freshDir.path}/eventpro.sqlite');
        final writer = AppDatabase.forTesting(graphFile);
        await writer.batch((batch) {
          batch.insertAll(writer.clients, [
            ClientsCompanion.insert(
              id: 'client-graph',
              createdAt: 1_700_000_000_000,
              type: 'individual',
              name: 'Cliente Grafo',
            ),
          ]);
          batch.insertAll(writer.catalogItems, [
            CatalogItemsCompanion.insert(
              id: 'catalog-graph',
              createdAt: 1_700_000_000_000,
              type: 'equipment',
              name: 'Item Grafo',
              category: 'sound',
              unit: 'un',
              priceCents: 5_000,
              active: true,
            ),
          ]);
          batch.insert(
            writer.quotes,
            QuotesCompanion.insert(
              id: 'quote-graph',
              number: 'ORC-2026-0200',
              status: 'draft',
              subtotalCents: 10_000,
              discountCents: 0,
              freightCents: 0,
              totalCents: 10_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
          batch.insert(
            writer.quoteClientSnapshots,
            QuoteClientSnapshotsCompanion.insert(
              quoteId: 'quote-graph',
              type: 'individual',
              displayName: 'Cliente Grafo',
            ),
          );
          batch.insert(
            writer.quoteLineItems,
            QuoteLineItemsCompanion.insert(
              id: 'line-graph',
              quoteId: 'quote-graph',
              sortOrder: 0,
              name: 'Item Grafo',
              unit: 'un',
              quantity: 2,
              unitPriceCents: 5_000,
              lineTotalCents: 10_000,
            ),
          );
          batch.insert(
            writer.quoteStatusHistory,
            QuoteStatusHistoryCompanion.insert(
              id: 'history-graph',
              quoteId: 'quote-graph',
              sortOrder: 0,
              newStatus: 'draft',
              changedAt: 1_700_000_000_000,
            ),
          );
        });
        await writer.close();

        final reopened = AppDatabase.forTesting(graphFile);
        addTearDown(reopened.close);

        expect(await reopened.select(reopened.clients).get(), hasLength(1));
        expect(
          await reopened.select(reopened.catalogItems).get(),
          hasLength(1),
        );
        expect(await reopened.select(reopened.quotes).get(), hasLength(1));
        expect(
          await reopened.select(reopened.quoteClientSnapshots).get(),
          hasLength(1),
        );
        expect(
          await reopened.select(reopened.quoteLineItems).get(),
          hasLength(1),
        );
        expect(
          await reopened.select(reopened.quoteStatusHistory).get(),
          hasLength(1),
        );

        final quote = await reopened.select(reopened.quotes).getSingle();
        expect(quote.id, 'quote-graph');
        expect(quote.number, 'ORC-2026-0200');
        expect(quote.totalCents, 10_000);
      },
    );

    test('PRAGMA integrity_check reports ok after complex operations', () async {
      await _insertQuoteGraph(database, quoteId: 'quote-integrity');

      await (database.update(database.quotes)..where(
            (tbl) => tbl.id.equals('quote-integrity'),
          ))
          .write(const QuotesCompanion(status: Value('sent')));

      await (database.delete(
        database.quoteLinePackageComponents,
      )..where((tbl) => tbl.id.equals('pkg-line-1'))).go();

      await (database.delete(
        database.quotes,
      )..where((tbl) => tbl.id.equals('quote-integrity'))).go();

      final result = await database
          .customSelect('PRAGMA integrity_check')
          .getSingle();
      expect(result.data.values.single, 'ok');
    });

    test(
      'all declared table indexes exist in the physical sqlite file',
      () async {
        const expectedIndexes = [
          'idx_clients_created_at',
          'idx_catalog_items_active',
          'idx_catalog_items_type',
          'idx_pkg_components_component',
          'idx_quotes_number',
          'idx_quotes_status',
          'idx_quotes_created_at',
          'idx_quotes_updated_at',
          'idx_quote_lines_quote_order',
          'idx_quote_pkg_line',
          'idx_quote_history_quote_order',
          'idx_agenda_blocks_start',
          'idx_agenda_blocks_end',
        ];

        final rows = await database
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type = 'index'",
            )
            .get();
        final actualIndexes = rows.map((row) => row.data['name']).toSet();

        for (final indexName in expectedIndexes) {
          expect(
            actualIndexes,
            contains(indexName),
            reason: 'expected index $indexName to exist in sqlite_master',
          );
        }
      },
    );

    test('agenda block validates end after start at the database level', () async {
      await database
          .into(database.agendaBlocks)
          .insert(
            AgendaBlocksCompanion.insert(
              id: 'block-1',
              title: 'Manutenção do galpão',
              start: 1_700_000_000_000,
              end: 1_700_003_600_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );

      final row = await (database.select(
        database.agendaBlocks,
      )..where((tbl) => tbl.id.equals('block-1'))).getSingle();
      expect(row.title, 'Manutenção do galpão');
      expect(row.start, 1_700_000_000_000);
      expect(row.end, 1_700_003_600_000);
    });

    test(
      'reopening the database file preserves persisted agenda blocks',
      () async {
        await database
            .into(database.agendaBlocks)
            .insert(
              AgendaBlocksCompanion.insert(
                id: 'block-reopen',
                title: 'Bloqueio recorrente',
                notes: const Value('Fechado para reforma'),
                start: 1_700_000_000_000,
                end: 1_700_003_600_000,
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );
        await database.close();

        final reopened = AppDatabase.forTesting(dbFile);
        addTearDown(reopened.close);

        final row = await reopened.select(reopened.agendaBlocks).getSingle();
        expect(row.id, 'block-reopen');
        expect(row.notes, 'Fechado para reforma');
      },
    );

    test(
      'inserting a duplicate agenda block id violates the primary key constraint',
      () async {
        await database
            .into(database.agendaBlocks)
            .insert(
              AgendaBlocksCompanion.insert(
                id: 'block-duplicate',
                title: 'Bloqueio original',
                start: 1_700_000_000_000,
                end: 1_700_003_600_000,
                createdAt: 1_700_000_000_000,
                updatedAt: 1_700_000_000_000,
              ),
            );

        await expectLater(
          database
              .into(database.agendaBlocks)
              .insert(
                AgendaBlocksCompanion.insert(
                  id: 'block-duplicate',
                  title: 'Bloqueio duplicado',
                  start: 1_700_100_000_000,
                  end: 1_700_103_600_000,
                  createdAt: 1_700_000_000_000,
                  updatedAt: 1_700_000_000_000,
                ),
              ),
          throwsA(predicate(_isUniqueConstraintViolation, 'unique constraint')),
        );
      },
    );

    test(
      'agenda_blocks rejects NULL in required columns at the database level',
      () async {
        Future<void> insertRawWithNull(String columnName) {
          final columns = <String, String>{
            'id': "'raw-null-$columnName'",
            'title': "'Bloqueio bruto'",
            'start': '1700000000000',
            'end': '1700003600000',
            'created_at': '1700000000000',
            'updated_at': '1700000000000',
          };
          columns[columnName] = 'NULL';
          final columnNames = columns.keys
              .map((name) => name == 'end' ? '"end"' : name)
              .join(', ');
          final values = columns.values.join(', ');
          return database.customStatement(
            'INSERT INTO agenda_blocks ($columnNames) VALUES ($values)',
          );
        }

        bool isNotNullViolation(Object error) {
          return error.toString().contains('NOT NULL constraint failed');
        }

        await expectLater(
          insertRawWithNull('title'),
          throwsA(predicate(isNotNullViolation, 'not null constraint')),
        );
        await expectLater(
          insertRawWithNull('start'),
          throwsA(predicate(isNotNullViolation, 'not null constraint')),
        );
        await expectLater(
          insertRawWithNull('end'),
          throwsA(predicate(isNotNullViolation, 'not null constraint')),
        );

        expect(await database.select(database.agendaBlocks).get(), isEmpty);
      },
    );

    test(
      'idx_agenda_blocks_start and idx_agenda_blocks_end exist and are honored by the query planner',
      () async {
        final indexRows = await database
            .customSelect(
              "SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = 'agenda_blocks'",
            )
            .get();
        final indexNames = indexRows.map((row) => row.data['name']).toSet();
        expect(indexNames, containsAll(['idx_agenda_blocks_start', 'idx_agenda_blocks_end']));

        final startPlan = await database
            .customSelect(
              'EXPLAIN QUERY PLAN SELECT * FROM agenda_blocks ORDER BY start',
            )
            .get();
        final startPlanDetail = startPlan
            .map((row) => row.data['detail'].toString())
            .join(' | ');
        expect(startPlanDetail, contains('idx_agenda_blocks_start'));

        final endPlan = await database
            .customSelect(
              'EXPLAIN QUERY PLAN SELECT * FROM agenda_blocks WHERE "end" > 0',
            )
            .get();
        final endPlanDetail = endPlan
            .map((row) => row.data['detail'].toString())
            .join(' | ');
        expect(endPlanDetail, contains('idx_agenda_blocks_end'));
      },
    );

    test(
      'AgendaBlocksDao.getAllOrdered returns rows ordered by start regardless of insertion order',
      () async {
        await database.batch((batch) {
          batch.insertAll(database.agendaBlocks, [
            AgendaBlocksCompanion.insert(
              id: 'block-middle',
              title: 'Bloqueio do meio',
              start: 1_700_050_000_000,
              end: 1_700_053_600_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
            AgendaBlocksCompanion.insert(
              id: 'block-last',
              title: 'Bloqueio final',
              start: 1_700_100_000_000,
              end: 1_700_103_600_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
            AgendaBlocksCompanion.insert(
              id: 'block-first',
              title: 'Bloqueio inicial',
              start: 1_700_000_000_000,
              end: 1_700_003_600_000,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          ]);
        });

        final ordered = await database.agendaBlocksDao.getAllOrdered();

        expect(ordered.map((row) => row.id).toList(), [
          'block-first',
          'block-middle',
          'block-last',
        ]);
      },
    );
  });
}

Future<void> _insertQuote(
  AppDatabase database, {
  required String id,
  required String number,
  String? validUntil,
}) {
  return database
      .into(database.quotes)
      .insert(
        QuotesCompanion.insert(
          id: id,
          number: number,
          status: 'draft',
          subtotalCents: 0,
          discountCents: 0,
          freightCents: 0,
          totalCents: 0,
          validUntil: Value(validUntil),
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );
}

Future<void> _insertQuoteGraph(
  AppDatabase database, {
  required String quoteId,
}) async {
  await database.batch((batch) {
    batch.insert(
      database.quotes,
      QuotesCompanion.insert(
        id: quoteId,
        number: 'ORC-2026-0100',
        status: 'draft',
        subtotalCents: 10_000,
        discountCents: 0,
        freightCents: 0,
        totalCents: 10_000,
        createdAt: 1_700_000_000_000,
        updatedAt: 1_700_000_000_000,
      ),
    );
    batch.insert(
      database.quoteClientSnapshots,
      QuoteClientSnapshotsCompanion.insert(
        quoteId: quoteId,
        type: 'individual',
        displayName: 'Cliente',
      ),
    );
    batch.insert(
      database.quoteEventSnapshots,
      QuoteEventSnapshotsCompanion.insert(quoteId: quoteId),
    );
    batch.insert(
      database.quoteCompanySnapshots,
      QuoteCompanySnapshotsCompanion.insert(
        quoteId: quoteId,
        captureStatus: 'configured',
        capturedAt: 1_700_000_000_000,
        identTradeName: 'EventPro',
      ),
    );
    batch.insert(
      database.quoteLineItems,
      QuoteLineItemsCompanion.insert(
        id: 'line-1',
        quoteId: quoteId,
        sortOrder: 0,
        name: 'Pacote',
        unit: 'pacote',
        quantity: 1,
        unitPriceCents: 10_000,
        lineTotalCents: 10_000,
      ),
    );
    batch.insert(
      database.quoteLinePackageComponents,
      QuoteLinePackageComponentsCompanion.insert(
        id: 'pkg-line-1',
        lineItemId: 'line-1',
        sortOrder: 0,
        name: 'Caixa',
        unit: 'un',
        typeLabel: 'Equipamento',
        categoryLabel: 'Som',
        quantityPerPackage: 2,
      ),
    );
    batch.insert(
      database.quoteStatusHistory,
      QuoteStatusHistoryCompanion.insert(
        id: 'history-1',
        quoteId: quoteId,
        sortOrder: 0,
        newStatus: 'draft',
        changedAt: 1_700_000_000_000,
      ),
    );
  });
}
