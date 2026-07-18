import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/equipment/data/repositories/drift_quote_equipment_repository.dart';
import 'package:eventpro/features/equipment/models/quote_equipment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftQuoteEquipmentRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftQuoteEquipmentRepository repository;

    final stamp = DateTime(2026, 7, 1, 9);

    Future<void> seedParents() async {
      await database.into(database.quotes).insert(
            QuotesCompanion.insert(
              id: 'quote-1',
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
      await database.into(database.quotes).insert(
            QuotesCompanion.insert(
              id: 'quote-2',
              number: 'ORC-2026-0002',
              status: 'draft',
              subtotalCents: 0,
              discountCents: 0,
              freightCents: 0,
              totalCents: 0,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
      await database.into(database.equipmentCategories).insert(
            EquipmentCategoriesCompanion.insert(
              id: 'cat-1',
              name: 'Som',
              active: true,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
      await database.into(database.equipments).insert(
            EquipmentsCompanion.insert(
              id: 'eq-1',
              name: 'Caixa',
              description: '',
              categoryId: 'cat-1',
              totalQuantity: 2,
              status: 'available',
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'quote_equipment_repo_test_',
      );
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftQuoteEquipmentRepository(database);
      await seedParents();
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('CRUD and listByQuoteId isolate quotes', () async {
      final a = QuoteEquipment(
        id: 'link-a',
        quoteId: 'quote-1',
        equipmentId: 'eq-1',
        quantity: 2,
        createdAt: stamp,
        updatedAt: stamp,
      );
      final b = QuoteEquipment(
        id: 'link-b',
        quoteId: 'quote-2',
        equipmentId: 'eq-1',
        quantity: 5,
        createdAt: stamp.add(const Duration(seconds: 1)),
        updatedAt: stamp,
      );

      await repository.insert(a);
      await repository.insert(b);

      expect(await repository.listByQuoteId('quote-1'), [a]);
      expect((await repository.listByQuoteId('quote-2')).single.quantity, 5);

      final updated = a.copyWith(quantity: 9);
      await repository.update(updated);
      expect((await repository.findById('link-a'))?.quantity, 9);

      await repository.delete('link-a');
      expect(await repository.findById('link-a'), isNull);
    });

    test('FK cascade deletes links when quote is deleted', () async {
      await repository.insert(
        QuoteEquipment(
          id: 'link-1',
          quoteId: 'quote-1',
          equipmentId: 'eq-1',
          quantity: 1,
          createdAt: stamp,
          updatedAt: stamp,
        ),
      );

      await (database.delete(database.quotes)
            ..where((row) => row.id.equals('quote-1')))
          .go();

      expect(await repository.listByQuoteId('quote-1'), isEmpty);
    });

    test('FK restrict blocks deleting equipment still linked', () async {
      await repository.insert(
        QuoteEquipment(
          id: 'link-1',
          quoteId: 'quote-1',
          equipmentId: 'eq-1',
          quantity: 1,
          createdAt: stamp,
          updatedAt: stamp,
        ),
      );

      await expectLater(
        (database.delete(database.equipments)
              ..where((row) => row.id.equals('eq-1')))
            .go(),
        throwsA(anything),
      );
    });

    test('FK rejects insert with unknown quote or equipment', () async {
      await expectLater(
        repository.insert(
          QuoteEquipment(
            id: 'bad-quote',
            quoteId: 'missing',
            equipmentId: 'eq-1',
            quantity: 1,
            createdAt: stamp,
            updatedAt: stamp,
          ),
        ),
        throwsA(anything),
      );
      await expectLater(
        repository.insert(
          QuoteEquipment(
            id: 'bad-eq',
            quoteId: 'quote-1',
            equipmentId: 'missing',
            quantity: 1,
            createdAt: stamp,
            updatedAt: stamp,
          ),
        ),
        throwsA(anything),
      );
    });
  });
}
