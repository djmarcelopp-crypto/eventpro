import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/models/equipment_category_delete_result.dart';
import 'package:eventpro/features/equipment/models/equipment_category_write_result.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/utils/equipment_category_service.dart';
import 'package:eventpro/features/equipment/utils/equipment_category_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_equipment_category_repository.dart';
import '../fakes/fake_equipment_repository.dart';

void main() {
  group('EquipmentCategoryService', () {
    late FakeEquipmentCategoryRepository categoryRepository;
    late FakeEquipmentRepository equipmentRepository;
    final fixedNow = DateTime(2030, 1, 1, 12, 0);
    final earlier = DateTime(2020, 1, 1);

    EquipmentCategoryService buildService({DateTime? now}) {
      return EquipmentCategoryService(
        categoryRepository: categoryRepository,
        equipmentRepository: equipmentRepository,
        clock: () => now ?? fixedNow,
      );
    }

    EquipmentCategory buildDraft({
      String id = '',
      String name = 'Som',
      String? description,
      bool active = true,
      DateTime? createdAt,
      DateTime? updatedAt,
    }) {
      return EquipmentCategory(
        id: id,
        name: name,
        description: description,
        active: active,
        createdAt: createdAt ?? earlier,
        updatedAt: updatedAt ?? earlier,
      );
    }

    setUp(() {
      categoryRepository = FakeEquipmentCategoryRepository();
      equipmentRepository = FakeEquipmentRepository();
    });

    group('create', () {
      test('persists a valid category using the injectable clock', () async {
        final service = buildService();

        final result = await service.create(buildDraft());

        expect(result.isSuccess, isTrue);
        expect(result.category!.id, isNotEmpty);
        expect(result.category!.createdAt, fixedNow);
        expect(result.category!.updatedAt, fixedNow);
        expect(
          await categoryRepository.findById(result.category!.id),
          isNotNull,
        );
      });

      test('rejects blank name without persisting', () async {
        final result = await buildService().create(buildDraft(name: ' '));

        expect(
          result.status,
          EquipmentCategoryWriteStatus.validationFailed,
        );
        expect(
          result.errors,
          contains(EquipmentCategoryValidator.nameRequiredError),
        );
        expect(await categoryRepository.listAll(), isEmpty);
      });
    });

    group('update', () {
      test('preserves createdAt, refreshes updatedAt and allows deactivation',
          () async {
        final created =
            (await buildService(now: earlier).create(buildDraft())).category!;
        final later = DateTime(2031, 3, 10);
        final service = buildService(now: later);

        final result = await service.update(
          created.copyWith(name: 'Áudio', active: false),
        );

        expect(result.isSuccess, isTrue);
        expect(result.category!.createdAt, earlier);
        expect(result.category!.updatedAt, later);
        expect(result.category!.active, isFalse);
        expect(result.category!.name, 'Áudio');
      });

      test('returns notFound for unknown id', () async {
        final result = await buildService().update(
          buildDraft(id: 'missing', name: 'Fantasma'),
        );

        expect(result.status, EquipmentCategoryWriteStatus.notFound);
      });
    });

    group('delete', () {
      test('deletes a category with no linked equipment', () async {
        final created =
            (await buildService().create(buildDraft())).category!;

        final result = await buildService().delete(created.id);

        expect(result.status, EquipmentCategoryDeleteStatus.deleted);
        expect(result.isDeleted, isTrue);
        expect(await categoryRepository.findById(created.id), isNull);
      });

      test('blocks deletion when equipment is linked', () async {
        final created =
            (await buildService().create(buildDraft())).category!;
        await equipmentRepository.insert(
          Equipment(
            id: 'eq-1',
            name: 'Caixa',
            categoryId: created.id,
            totalQuantity: 1,
            status: EquipmentStatus.available,
            createdAt: earlier,
            updatedAt: earlier,
          ),
        );
        await equipmentRepository.insert(
          Equipment(
            id: 'eq-2',
            name: 'Microfone',
            categoryId: created.id,
            totalQuantity: 2,
            status: EquipmentStatus.available,
            createdAt: earlier,
            updatedAt: earlier,
          ),
        );

        final result = await buildService().delete(created.id);

        expect(result.status, EquipmentCategoryDeleteStatus.blockedByUsage);
        expect(result.isBlockedByUsage, isTrue);
        expect(result.blockingEquipmentCount, 2);
        expect(await categoryRepository.findById(created.id), isNotNull);
      });

      test('returns notFound for unknown id', () async {
        final result = await buildService().delete('missing');

        expect(result.status, EquipmentCategoryDeleteStatus.notFound);
      });
    });
  });
}
