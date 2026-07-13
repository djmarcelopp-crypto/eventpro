import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';

void main() {
  group('CatalogItem', () {
    test('fromForm gera id e createdAt automaticamente', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: ' Caixa de som ',
        category: CatalogCategory.sound,
        unit: 'un',
        price: 150,
      );

      expect(item.name, 'Caixa de som');
      expect(int.tryParse(item.id), isNotNull);
      expect(item.createdAt, isNotNull);
      expect(item.active, isTrue);
      expect(item.imageReference, isNull);
      expect(item.description, isNull);
    });

    test('preserva imageReference quando informada', () {
      final item = CatalogItem.fromForm(
        type: CatalogItemType.service,
        name: 'DJ',
        category: CatalogCategory.dj,
        unit: 'hora',
        price: 500,
        imageReference: ' catalog/items/abc.jpg ',
      );

      expect(item.imageReference, 'catalog/items/abc.jpg');
    });

    test('copyWith limpa imageReference e atualiza campos', () {
      final createdAt = DateTime(2024, 6, 15);
      final item = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Painel LED',
        category: CatalogCategory.ledPanel,
        unit: 'm²',
        price: 80,
        id: 'item-1',
        createdAt: createdAt,
        imageReference: 'ref-1',
      );

      final updated = item.copyWith(
        name: 'Painel LED P3',
        clearImageReference: true,
      );

      expect(updated.id, 'item-1');
      expect(updated.createdAt, createdAt);
      expect(updated.name, 'Painel LED P3');
      expect(updated.imageReference, isNull);
    });
  });
}
