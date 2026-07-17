import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/equipment/data/mappers/quote_equipment_mapper.dart';
import 'package:eventpro/features/equipment/models/quote_equipment.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('QuoteEquipmentMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 7, 1, 12);
    final updatedAt = DateTime(2026, 7, 2, 15);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp(
        'quote_equipment_mapper_test_',
      );
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

    test('round-trips all fields', () async {
      final original = QuoteEquipment(
        id: 'link-1',
        quoteId: 'quote-1',
        equipmentId: 'eq-1',
        quantity: 4,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      await database.into(database.quoteEquipmentItems).insert(
            QuoteEquipmentMapper.toInsertCompanion(original),
          );
      final row = await (database.select(database.quoteEquipmentItems)
            ..where((tbl) => tbl.id.equals('link-1')))
          .getSingle();
      final restored = QuoteEquipmentMapper.toDomain(row);

      expect(restored.id, original.id);
      expect(restored.quoteId, original.quoteId);
      expect(restored.equipmentId, original.equipmentId);
      expect(restored.quantity, original.quantity);
      expect(restored.createdAt, original.createdAt);
      expect(restored.updatedAt, original.updatedAt);
    });
  });
}
