import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';

CatalogItem _sampleItem({
  String id = 'item-1',
  DateTime? createdAt,
  String? imageReference,
}) {
  return CatalogItem.fromForm(
    type: CatalogItemType.equipment,
    name: 'Caixa de som',
    category: CatalogCategory.sound,
    unit: 'un',
    price: 200,
    id: id,
    createdAt: createdAt ?? DateTime(2024, 6, 15),
    imageReference: imageReference,
  );
}

void main() {
  group('CatalogNotifier', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('inicia com lista vazia', () {
      expect(container.read(catalogProvider), isEmpty);
    });

    test('addItem adiciona item à lista', () {
      final notifier = container.read(catalogProvider.notifier);
      notifier.addItem(_sampleItem());

      final items = container.read(catalogProvider);
      expect(items, hasLength(1));
      expect(items.first.name, 'Caixa de som');
    });

    test('findById retorna item existente ou null', () {
      final notifier = container.read(catalogProvider.notifier);
      notifier.addItem(_sampleItem());

      expect(notifier.findById('item-1')?.name, 'Caixa de som');
      expect(notifier.findById('missing'), isNull);
    });

    test('updateItem preserva id e createdAt', () {
      final createdAt = DateTime(2024, 1, 10, 8, 30);
      final notifier = container.read(catalogProvider.notifier);
      notifier.addItem(_sampleItem(createdAt: createdAt));

      notifier.updateItem(
        CatalogItem.fromForm(
          type: CatalogItemType.service,
          name: 'DJ Profissional',
          category: CatalogCategory.dj,
          unit: 'hora',
          price: 600,
          id: 'wrong-id',
          createdAt: DateTime(2025, 1, 1),
        ).copyWith(id: 'item-1'),
      );

      final updated = container.read(catalogProvider).single;
      expect(updated.id, 'item-1');
      expect(updated.createdAt, createdAt);
      expect(updated.name, 'DJ Profissional');
    });

    test('deleteItem remove item da lista', () {
      final notifier = container.read(catalogProvider.notifier);
      notifier.addItem(_sampleItem());
      notifier.deleteItem('item-1');

      expect(container.read(catalogProvider), isEmpty);
    });
  });
}
