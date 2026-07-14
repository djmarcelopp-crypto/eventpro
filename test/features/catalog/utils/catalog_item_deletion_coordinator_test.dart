import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_delete_result.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/models/catalog_package_component.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';
import 'package:eventpro/features/catalog/utils/catalog_item_deletion_coordinator.dart';

import '../fakes/fake_catalog_image_storage_service.dart';
import 'catalog_package_dependency_checker_test.dart';

void main() {
  group('CatalogItemDeletionCoordinator', () {
    late ProviderContainer container;
    late FakeCatalogImageStorageService storage;

    setUp(() {
      storage = FakeCatalogImageStorageService();
      container = ProviderContainer(
        overrides: [
          // image storage is passed directly to coordinator
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    Future<CatalogDeleteResult> delete(String id) {
      final notifier = container.read(catalogProvider.notifier);
      return CatalogItemDeletionCoordinator.deletePermanently(
        itemId: id,
        notifier: notifier,
        imageStorage: storage,
        currentItems: container.read(catalogProvider),
      );
    }

    test('exclui equipamento sem foto', () async {
      final eq = equipment();
      container.read(catalogProvider.notifier).addItem(eq);

      final result = await delete(eq.id);

      expect(result.status, CatalogDeleteStatus.deleted);
      expect(container.read(catalogProvider), isEmpty);
    });

    test('exclui serviço', () async {
      final service = CatalogItem.fromForm(
        type: CatalogItemType.service,
        name: 'DJ',
        category: CatalogCategory.dj,
        unit: 'Evento',
        price: 2500,
        id: 'svc-1',
        createdAt: DateTime(2024, 1, 1),
      );
      container.read(catalogProvider.notifier).addItem(service);

      final result = await delete(service.id);

      expect(result.status, CatalogDeleteStatus.deleted);
      expect(container.read(catalogProvider), isEmpty);
    });

    test('exclui pacote sem dependentes', () async {
      final pkg = packageItem(
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: equipment(),
            quantityPerPackage: 1,
          ),
        ],
      );
      container.read(catalogProvider.notifier).addItem(equipment());
      container.read(catalogProvider.notifier).addItem(pkg);

      final result = await delete(pkg.id);

      expect(result.status, CatalogDeleteStatus.deleted);
      expect(
        container.read(catalogProvider).map((item) => item.id).toList(),
        ['eq-1'],
      );
    });

    test('bloqueia item usado por pacote ativo', () async {
      final eq = equipment();
      final pkg = packageItem(
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: eq,
            quantityPerPackage: 1,
          ),
        ],
      );
      container.read(catalogProvider.notifier).addItem(eq);
      container.read(catalogProvider.notifier).addItem(pkg);

      final result = await delete(eq.id);

      expect(result.status, CatalogDeleteStatus.blockedByPackages);
      expect(result.blockingPackageNames, ['Pacote Festa']);
      expect(container.read(catalogProvider), hasLength(2));
    });

    test('bloqueia item usado por pacote inativo', () async {
      final eq = equipment();
      final pkg = packageItem(
        active: false,
        name: 'Pacote Arquivado',
        components: [
          CatalogPackageComponent.fromCatalogItem(
            item: eq,
            quantityPerPackage: 1,
          ),
        ],
      );
      container.read(catalogProvider.notifier).addItem(eq);
      container.read(catalogProvider.notifier).addItem(pkg);

      final result = await delete(eq.id);

      expect(result.status, CatalogDeleteStatus.blockedByPackages);
      expect(result.blockingPackageNames, ['Pacote Arquivado']);
    });

    test('remove foto após exclusão', () async {
      final eq = equipment().copyWith(imageReference: 'catalog/items/eq.jpg');
      storage.seedCommitted('catalog/items/eq.jpg', Uint8List.fromList([1, 2, 3]));
      container.read(catalogProvider.notifier).addItem(eq);

      final result = await delete(eq.id);

      expect(result.status, CatalogDeleteStatus.deleted);
      expect(storage.deleteLog, ['catalog/items/eq.jpg']);
      expect(await storage.exists('catalog/items/eq.jpg'), isFalse);
    });

    test('falha na foto mantém cadastro excluído com aviso', () async {
      storage.deleteCommittedShouldFail = true;
      final eq = equipment().copyWith(imageReference: 'catalog/items/eq.jpg');
      storage.seedCommitted('catalog/items/eq.jpg', Uint8List.fromList([1, 2, 3]));
      container.read(catalogProvider.notifier).addItem(eq);

      final result = await delete(eq.id);

      expect(result.status, CatalogDeleteStatus.deletedWithImageCleanupWarning);
      expect(container.read(catalogProvider), isEmpty);
    });

    test('foto de outro item permanece', () async {
      final eq = equipment(id: 'eq-1').copyWith(
        imageReference: 'catalog/items/eq.jpg',
      );
      final other = equipment(
        id: 'eq-2',
        name: 'Microfone',
      ).copyWith(imageReference: 'catalog/items/mic.jpg');
      storage.seedCommitted('catalog/items/eq.jpg', Uint8List.fromList([1]));
      storage.seedCommitted('catalog/items/mic.jpg', Uint8List.fromList([2]));
      container.read(catalogProvider.notifier).addItem(eq);
      container.read(catalogProvider.notifier).addItem(other);

      await delete(eq.id);

      expect(storage.deleteLog, ['catalog/items/eq.jpg']);
      expect(await storage.exists('catalog/items/mic.jpg'), isTrue);
    });

    test('id inexistente retorna notFound', () async {
      final result = await delete('missing');

      expect(result.status, CatalogDeleteStatus.notFound);
    });
  });
}
