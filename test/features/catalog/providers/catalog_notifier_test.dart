import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/data/repositories/catalog_repository.dart';
import 'package:eventpro/features/catalog/models/catalog_delete_result.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';

import '../fakes/catalog_repository_test_overrides.dart';
import '../fakes/fake_catalog_repository.dart';

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

ProviderContainer _createContainer({CatalogRepository? repository}) {
  final container = ProviderContainer(
    overrides: catalogRepositoryOverrides(repository: repository),
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('CatalogNotifier', () {
    test('inicia com lista vazia', () {
      final container = _createContainer();
      expect(container.read(catalogProvider), isEmpty);
    });

    test('hydrate substitui o state pela lista informada', () {
      final container = _createContainer();
      final items = [
        _sampleItem(id: 'item-1'),
        _sampleItem(id: 'item-2'),
      ];

      container.read(catalogProvider.notifier).hydrate(items);

      expect(container.read(catalogProvider), items);
    });

    test('addItem adiciona item à lista', () async {
      final container = _createContainer();
      final notifier = container.read(catalogProvider.notifier);

      final saved = await notifier.addItem(_sampleItem());

      expect(saved, isTrue);
      final items = container.read(catalogProvider);
      expect(items, hasLength(1));
      expect(items.first.name, 'Caixa de som');
    });

    test('findById retorna item existente ou null', () async {
      final container = _createContainer();
      final notifier = container.read(catalogProvider.notifier);
      await notifier.addItem(_sampleItem());

      expect(notifier.findById('item-1')?.name, 'Caixa de som');
      expect(notifier.findById('missing'), isNull);
    });

    test('updateItem preserva id, createdAt e imageReference', () async {
      final createdAt = DateTime(2024, 1, 10, 8, 30);
      final container = _createContainer();
      final notifier = container.read(catalogProvider.notifier);
      await notifier.addItem(
        _sampleItem(
          createdAt: createdAt,
          imageReference: 'catalog/items/photo.jpg',
        ),
      );

      final saved = await notifier.updateItem(
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

      expect(saved, isTrue);
      final updated = container.read(catalogProvider).single;
      expect(updated.id, 'item-1');
      expect(updated.createdAt, createdAt);
      expect(updated.imageReference, 'catalog/items/photo.jpg');
      expect(updated.name, 'DJ Profissional');
    });

    test('updateItem altera status ativo', () async {
      final container = _createContainer();
      final notifier = container.read(catalogProvider.notifier);
      await notifier.addItem(_sampleItem());

      final existing = notifier.findById('item-1')!;
      await notifier.updateItem(existing.copyWith(active: false));

      expect(container.read(catalogProvider).single.active, isFalse);
    });

    test('updateItem ignora ID inexistente', () async {
      final container = _createContainer();
      final notifier = container.read(catalogProvider.notifier);
      await notifier.addItem(_sampleItem());

      final saved = await notifier.updateItem(
        CatalogItem.fromForm(
          type: CatalogItemType.service,
          name: 'Item fantasma',
          category: CatalogCategory.dj,
          unit: 'hora',
          price: 300,
          id: 'missing-id',
        ),
      );

      expect(saved, isFalse);
      final items = container.read(catalogProvider);
      expect(items, hasLength(1));
      expect(items.single.name, 'Caixa de som');
    });

    test('updateItem remove imageReference explicitamente', () async {
      final container = _createContainer();
      final notifier = container.read(catalogProvider.notifier);
      await notifier.addItem(
        _sampleItem(imageReference: 'catalog/images/old.jpg'),
      );

      final existing = notifier.findById('item-1')!;
      await notifier.updateItem(
        existing.copyWith(name: 'Sem foto'),
        clearImageReference: true,
      );

      expect(container.read(catalogProvider).single.imageReference, isNull);
      expect(container.read(catalogProvider).single.name, 'Sem foto');
    });

    test('updateItem mantém posição na lista', () async {
      final container = _createContainer();
      final notifier = container.read(catalogProvider.notifier);
      await notifier.addItem(
        _sampleItem(id: 'item-1', createdAt: DateTime(2024, 1, 1)),
      );
      await notifier.addItem(
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
      await notifier.addItem(
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

      await notifier.updateItem(
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
      expect(
        items.map((item) => item.id).toList(),
        ['item-1', 'item-2', 'item-3'],
      );
      expect(items.first.name, 'Caixa atualizada');
    });

    test('deleteItem remove somente o item indicado preservando ordem', () async {
      final container = _createContainer();
      final notifier = container.read(catalogProvider.notifier);
      await notifier.addItem(_sampleItem(id: 'item-1'));
      await notifier.addItem(
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

      final result = await notifier.deleteItem('item-1');

      expect(result.status, CatalogDeleteStatus.deleted);
      expect(
        container.read(catalogProvider).map((item) => item.id).toList(),
        ['item-2'],
      );
    });

    test('deleteItem retorna notFound para ID inexistente', () async {
      final container = _createContainer();
      final notifier = container.read(catalogProvider.notifier);
      await notifier.addItem(_sampleItem());

      final result = await notifier.deleteItem('missing');

      expect(result.status, CatalogDeleteStatus.notFound);
      expect(container.read(catalogProvider), hasLength(1));
    });

    test('falha de insert não altera state', () async {
      final repository = FakeCatalogRepository()
        ..shouldFailOnNextOperation = true;
      final container = _createContainer(repository: repository);

      final saved = await container
          .read(catalogProvider.notifier)
          .addItem(_sampleItem());

      expect(saved, isFalse);
      expect(container.read(catalogProvider), isEmpty);
    });

    test('falha de update não altera state', () async {
      final repository = FakeCatalogRepository();
      final container = _createContainer(repository: repository);
      final notifier = container.read(catalogProvider.notifier);
      await notifier.addItem(_sampleItem());
      repository.shouldFailOnNextOperation = true;

      final saved = await notifier.updateItem(
        _sampleItem().copyWith(name: 'Nome novo'),
      );

      expect(saved, isFalse);
      expect(container.read(catalogProvider).single.name, 'Caixa de som');
    });

    test('falha de delete retorna failure e preserva state', () async {
      final repository = FakeCatalogRepository();
      final container = _createContainer(repository: repository);
      final notifier = container.read(catalogProvider.notifier);
      await notifier.addItem(_sampleItem());
      repository.shouldFailOnNextOperation = true;

      final result = await notifier.deleteItem('item-1');

      expect(result.status, CatalogDeleteStatus.failure);
      expect(container.read(catalogProvider), hasLength(1));
    });
  });
}
