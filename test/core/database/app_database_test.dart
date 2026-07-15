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

    test('schemaVersion is 1', () {
      expect(database.schemaVersion, 1);
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
