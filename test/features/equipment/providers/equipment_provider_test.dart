import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/models/equipment_write_result.dart';
import 'package:eventpro/features/equipment/providers/equipment_filters_provider.dart';
import 'package:eventpro/features/equipment/providers/equipment_provider.dart';
import 'package:eventpro/features/equipment/providers/filtered_equipment_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/equipment_repository_test_overrides.dart';
import '../fakes/fake_equipment_category_repository.dart';
import '../fakes/fake_equipment_repository.dart';
import '../equipment_test_helpers.dart';

void main() {
  group('EquipmentNotifier', () {
    late FakeEquipmentRepository equipmentRepository;
    late FakeEquipmentCategoryRepository categoryRepository;
    late ProviderContainer container;
    final fixedNow = DateTime(2030, 1, 1, 12);

    setUp(() async {
      equipmentRepository = FakeEquipmentRepository();
      categoryRepository = FakeEquipmentCategoryRepository(
        initialCategories: [buildTestCategory()],
      );
      container = ProviderContainer(
        overrides: equipmentRepositoryOverrides(
          equipmentRepository: equipmentRepository,
          categoryRepository: categoryRepository,
          clock: () => fixedNow,
        ),
      );
      await container.read(equipmentProvider.future);
    });

    tearDown(() => container.dispose());

    test('addEquipment persists via service and updates state', () async {
      final result = await container
          .read(equipmentProvider.notifier)
          .addEquipment(
            Equipment(
              id: '',
              name: 'Microfone',
              categoryId: 'cat-sound',
              totalQuantity: 3,
              status: EquipmentStatus.available,
              createdAt: fixedNow,
              updatedAt: fixedNow,
            ),
          );

      expect(result.isSuccess, isTrue);
      expect(result.status, EquipmentWriteStatus.success);
      final items = container.read(equipmentProvider).value!;
      expect(items, hasLength(1));
      expect(items.first.name, 'Microfone');
      expect(items.first.id, isNotEmpty);
    });

    test('updateEquipment and deleteEquipment update state', () async {
      final created = await container
          .read(equipmentProvider.notifier)
          .addEquipment(buildTestEquipment(id: '', name: 'LED'));
      final equipment = created.equipment!;

      final updated = await container
          .read(equipmentProvider.notifier)
          .updateEquipment(
            equipment.copyWith(
              name: 'LED Bar',
              status: EquipmentStatus.maintenance,
            ),
          );
      expect(updated.isSuccess, isTrue);
      expect(
        container.read(equipmentProvider).value!.first.name,
        'LED Bar',
      );

      final deleted = await container
          .read(equipmentProvider.notifier)
          .deleteEquipment(equipment.id);
      expect(deleted.isDeleted, isTrue);
      expect(container.read(equipmentProvider).value, isEmpty);
    });

    test('filters apply category, status and name query', () async {
      container.read(equipmentProvider.notifier).hydrate([
        buildTestEquipment(id: '1', name: 'Caixa A'),
        buildTestEquipment(
          id: '2',
          name: 'Microfone B',
          status: EquipmentStatus.maintenance,
        ),
        buildTestEquipment(
          id: '3',
          name: 'Caixa C',
          categoryId: 'other',
        ),
      ]);

      container
          .read(equipmentFiltersProvider.notifier)
          .setNameQuery('caixa');
      expect(
        container.read(filteredEquipmentProvider).value!.map((e) => e.id),
        ['1', '3'],
      );

      container
          .read(equipmentFiltersProvider.notifier)
          .setStatus(EquipmentStatus.available);
      expect(
        container.read(filteredEquipmentProvider).value!.map((e) => e.id),
        ['1', '3'],
      );

      container
          .read(equipmentFiltersProvider.notifier)
          .setCategoryId('cat-sound');
      expect(
        container.read(filteredEquipmentProvider).value!.map((e) => e.id),
        ['1'],
      );
    });
  });
}
