import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuoteEquipmentDao', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('quote_equipment_dao_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);

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
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('CRUD and listByQuoteId', () async {
      final dao = database.quoteEquipmentDao;
      await dao.insertRow(
        QuoteEquipmentItemsCompanion.insert(
          id: 'link-1',
          quoteId: 'quote-1',
          equipmentId: 'eq-1',
          quantity: 3,
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );

      expect((await dao.getById('link-1'))?.quantity, 3);
      expect(await dao.getAllByQuoteId('quote-1'), hasLength(1));

      expect(
        await dao.updateRow(
          QuoteEquipmentItemsCompanion.insert(
            id: 'link-1',
            quoteId: 'quote-1',
            equipmentId: 'eq-1',
            quantity: 9,
            createdAt: 1_700_000_000_000,
            updatedAt: 1_700_000_100_000,
          ),
        ),
        isTrue,
      );
      expect((await dao.getById('link-1'))?.quantity, 9);
      expect(await dao.deleteById('link-1'), isTrue);
      expect(await dao.getById('link-1'), isNull);
    });
  });
}
