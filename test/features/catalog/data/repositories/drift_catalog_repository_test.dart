import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/catalog_package_constants.dart';
import 'package:eventpro/features/catalog/data/repositories/drift_catalog_repository.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftCatalogRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftCatalogRepository repository;

    CatalogItem buildEquipment({
      required String id,
      required String name,
      DateTime? createdAt,
      double price = 100,
      bool active = true,
    }) {
      return CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: name,
        category: CatalogCategory.sound,
        unit: 'Unidade',
        price: price,
        active: active,
        id: id,
        createdAt: createdAt ?? DateTime(2024, 3, 2, 10, 15),
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('catalog_repo_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftCatalogRepository(database);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('CRUD persists fields and preserves registration order', () async {
      final first = buildEquipment(id: 'item-1', name: 'Caixa de som');
      final second = buildEquipment(
        id: 'item-2',
        name: 'Painel LED',
        createdAt: DateTime(2024, 3, 3),
        price: 2500.5,
      );

      await repository.insert(first);
      await repository.insert(second);

      final listed = await repository.listAll();
      expect(listed.map((item) => item.name).toList(), [
        'Caixa de som',
        'Painel LED',
      ]);
      expect(listed.last.price, 2500.5);

      final loaded = await repository.findById('item-1');
      expect(loaded?.name, 'Caixa de som');

      final updated = first.copyWith(name: 'Caixa Atualizada');
      await repository.update(updated);
      expect((await repository.findById('item-1'))?.name, 'Caixa Atualizada');

      await repository.delete('item-1');
      expect(await repository.findById('item-1'), isNull);
      expect((await repository.listAll()).single.id, 'item-2');
    });

    test('update preserva createdAt quando notifier já resolveu isso', () async {
      final item = buildEquipment(id: 'item-3', name: 'Mesa de som');
      await repository.insert(item);

      final updated = item.copyWith(name: 'Mesa Nova');
      await repository.update(updated);

      final restored = await repository.findById('item-3');
      expect(restored?.createdAt, item.createdAt);
      expect(restored?.name, 'Mesa Nova');
    });

    test('update de item inexistente lança StateError', () async {
      final ghost = buildEquipment(id: 'missing', name: 'Fantasma');
      await expectLater(
        repository.update(ghost),
        throwsA(isA<StateError>()),
      );
    });

    test('delete de item inexistente lança StateError', () async {
      await expectLater(
        repository.delete('missing'),
        throwsA(isA<StateError>()),
      );
    });

    test('insert e leitura de pacote persiste componentes atomicamente', () async {
      final component = buildEquipment(id: 'component-1', name: 'Caixa');
      await repository.insert(component);

      final package = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote Festa',
        category: CatalogCategory.dj,
        unit: CatalogPackageConstants.unit,
        price: 900,
        id: 'package-1',
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: component,
            quantityPerPackage: 2,
          ),
        ],
      );

      await repository.insert(package);

      final loaded = await repository.findById('package-1');
      expect(loaded?.isPackage, isTrue);
      expect(loaded?.components, hasLength(1));
      expect(loaded?.components.single.catalogItemId, 'component-1');
      expect(loaded?.components.single.quantityPerPackage, 2);

      final listed = await repository.listAll();
      final listedPackage = listed.firstWhere((item) => item.id == 'package-1');
      expect(listedPackage.components, hasLength(1));
    });

    test('update de pacote substitui componentes por completo', () async {
      final componentA = buildEquipment(id: 'component-a', name: 'Caixa A');
      final componentB = buildEquipment(id: 'component-b', name: 'Caixa B');
      await repository.insert(componentA);
      await repository.insert(componentB);

      final package = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote Som',
        category: CatalogCategory.sound,
        unit: CatalogPackageConstants.unit,
        price: 500,
        id: 'package-2',
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: componentA,
            quantityPerPackage: 1,
          ),
        ],
      );
      await repository.insert(package);

      final updatedPackage = package.copyWith(
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: componentB,
            quantityPerPackage: 3,
          ),
        ],
      );
      await repository.update(updatedPackage);

      final loaded = await repository.findById('package-2');
      expect(loaded?.components, hasLength(1));
      expect(loaded?.components.single.catalogItemId, 'component-b');
      expect(loaded?.components.single.quantityPerPackage, 3);
    });

    test(
      'excluir item referenciado como componente é rejeitado pela FK',
      () async {
        final component = buildEquipment(id: 'component-c', name: 'Caixa C');
        await repository.insert(component);

        final package = CatalogItem.fromForm(
          type: CatalogItemType.package,
          name: 'Pacote Protegido',
          category: CatalogCategory.dj,
          unit: CatalogPackageConstants.unit,
          price: 700,
          id: 'package-3',
          components: [
            CatalogPackageComponent.fromCatalogItem(
              item: component,
              quantityPerPackage: 1,
            ),
          ],
        );
        await repository.insert(package);

        await expectLater(
          repository.delete('component-c'),
          throwsA(anything),
        );

        expect(await repository.findById('component-c'), isNotNull);
      },
    );

    test('excluir pacote remove seus componentes em cascata', () async {
      final component = buildEquipment(id: 'component-d', name: 'Caixa D');
      await repository.insert(component);

      final package = CatalogItem.fromForm(
        type: CatalogItemType.package,
        name: 'Pacote Cascata',
        category: CatalogCategory.dj,
        unit: CatalogPackageConstants.unit,
        price: 700,
        id: 'package-4',
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: component,
            quantityPerPackage: 1,
          ),
        ],
      );
      await repository.insert(package);

      await repository.delete('package-4');

      expect(await repository.findById('package-4'), isNull);
      expect(await repository.findById('component-d'), isNotNull);
    });

    test('close and reopen database keeps persisted catalog items', () async {
      await repository.insert(
        buildEquipment(id: 'item-persist', name: 'Persistido'),
      );
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftCatalogRepository(reopenedDb);

      final items = await reopenedRepository.listAll();
      expect(items, hasLength(1));
      expect(items.single.name, 'Persistido');
    });
  });
}
