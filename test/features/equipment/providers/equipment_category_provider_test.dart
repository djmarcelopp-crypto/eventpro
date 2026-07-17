import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/providers/equipment_category_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/equipment_repository_test_overrides.dart';
import '../fakes/fake_equipment_category_repository.dart';
import '../fakes/fake_equipment_repository.dart';

void main() {
  group('EquipmentCategoryNotifier', () {
    late ProviderContainer container;
    final fixedNow = DateTime(2030, 1, 1, 12);

    setUp(() async {
      container = ProviderContainer(
        overrides: equipmentRepositoryOverrides(
          equipmentRepository: FakeEquipmentRepository(),
          categoryRepository: FakeEquipmentCategoryRepository(),
          clock: () => fixedNow,
        ),
      );
      await container.read(equipmentCategoryProvider.future);
    });

    tearDown(() => container.dispose());

    test('CRUD categories via service', () async {
      final created = await container
          .read(equipmentCategoryProvider.notifier)
          .addCategory(
            EquipmentCategory(
              id: '',
              name: 'Iluminação',
              createdAt: fixedNow,
              updatedAt: fixedNow,
            ),
          );
      expect(created.isSuccess, isTrue);
      expect(container.read(equipmentCategoryProvider).value, hasLength(1));

      final category = created.category!;
      final updated = await container
          .read(equipmentCategoryProvider.notifier)
          .updateCategory(category.copyWith(name: 'Luz'));
      expect(updated.isSuccess, isTrue);
      expect(
        container.read(equipmentCategoryProvider).value!.first.name,
        'Luz',
      );

      final deleted = await container
          .read(equipmentCategoryProvider.notifier)
          .deleteCategory(category.id);
      expect(deleted.isDeleted, isTrue);
      expect(container.read(equipmentCategoryProvider).value, isEmpty);
    });
  });
}
