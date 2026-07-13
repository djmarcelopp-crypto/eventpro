import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';

CatalogItem _sampleItem({
  String id = 'item-1',
  DateTime? createdAt,
  String? imageReference,
  bool active = true,
}) {
  return CatalogItem.fromForm(
    type: CatalogItemType.equipment,
    name: 'Caixa de som',
    category: CatalogCategory.sound,
    unit: 'un',
    price: 200,
    active: active,
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

    test('updateItem preserva id, createdAt e imageReference', () {
      final createdAt = DateTime(2024, 1, 10, 8, 30);
      final notifier = container.read(catalogProvider.notifier);
      notifier.addItem(
        _sampleItem(
          createdAt: createdAt,
          imageReference: 'catalog/items/photo.jpg',
        ),
      );

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
      expect(updated.imageReference, 'catalog/items/photo.jpg');
      expect(updated.name, 'DJ Profissional');
    });

    test('updateItem altera status ativo', () {
      final notifier = container.read(catalogProvider.notifier);
      notifier.addItem(_sampleItem());

      final existing = notifier.findById('item-1')!;
      notifier.updateItem(existing.copyWith(active: false));

      expect(container.read(catalogProvider).single.active, isFalse);
    });

    test('updateItem ignora ID inexistente', () {
      final notifier = container.read(catalogProvider.notifier);
      notifier.addItem(_sampleItem());

      notifier.updateItem(
        CatalogItem.fromForm(
          type: CatalogItemType.service,
          name: 'Item fantasma',
          category: CatalogCategory.dj,
          unit: 'hora',
          price: 300,
          id: 'missing-id',
        ),
      );

      final items = container.read(catalogProvider);
      expect(items, hasLength(1));
      expect(items.single.name, 'Caixa de som');
    });

    test('updateItem remove imageReference explicitamente', () {
      final notifier = container.read(catalogProvider.notifier);
      notifier.addItem(
        _sampleItem(imageReference: 'catalog/images/old.jpg'),
      );

      final existing = notifier.findById('item-1')!;
      notifier.updateItem(
        existing.copyWith(name: 'Sem foto'),
        clearImageReference: true,
      );

      expect(container.read(catalogProvider).single.imageReference, isNull);
      expect(container.read(catalogProvider).single.name, 'Sem foto');
    });

    test('updateItem mantém posição na lista', () {
      final notifier = container.read(catalogProvider.notifier);
      notifier.addItem(
        _sampleItem(id: 'item-1', createdAt: DateTime(2024, 1, 1)),
      );
      notifier.addItem(
        CatalogItem.fromForm(
          type: CatalogItemType.service,
          name: 'DJ',
          category: CatalogCategory.dj,
          unit: 'hora',
          price: 500,
          id: 'item-2',
          createdAt: DateTime(2024, 2, 1),
        ),
      );
      notifier.addItem(
        CatalogItem.fromForm(
          type: CatalogItemType.equipment,
          name: 'Painel LED',
          category: CatalogCategory.ledPanel,
          unit: 'Diária',
          price: 800,
          id: 'item-3',
          createdAt: DateTime(2024, 3, 1),
        ),
      );

      notifier.updateItem(
        CatalogItem.fromForm(
          type: CatalogItemType.equipment,
          name: 'Caixa atualizada',
          category: CatalogCategory.sound,
          unit: 'un',
          price: 250,
          id: 'item-1',
          createdAt: DateTime(2099, 1, 1),
        ),
      );

      final items = container.read(catalogProvider);
      expect(items.map((item) => item.id).toList(), ['item-1', 'item-2', 'item-3']);
      expect(items.first.name, 'Caixa atualizada');
    });
  });
}
