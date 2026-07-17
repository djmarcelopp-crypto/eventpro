import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';
import 'package:eventpro/features/equipment/models/equipment_delete_result.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:eventpro/features/equipment/models/equipment_write_result.dart';
import 'package:eventpro/features/equipment/utils/equipment_service.dart';
import 'package:eventpro/features/equipment/utils/equipment_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_equipment_category_repository.dart';
import '../fakes/fake_equipment_repository.dart';

void main() {
  group('EquipmentService', () {
    late FakeEquipmentCategoryRepository categoryRepository;
    late FakeEquipmentRepository equipmentRepository;
    final fixedNow = DateTime(2030, 1, 1, 12, 0);
    final earlier = DateTime(2020, 1, 1);

    EquipmentService buildService({DateTime? now}) {
      return EquipmentService(
        equipmentRepository: equipmentRepository,
        categoryRepository: categoryRepository,
        clock: () => now ?? fixedNow,
      );
    }

    EquipmentCategory buildCategory({
      String id = 'category-1',
      bool active = true,
    }) {
      return EquipmentCategory(
        id: id,
        name: 'Som',
        active: active,
        createdAt: earlier,
        updatedAt: earlier,
      );
    }

    Equipment buildDraft({
      String id = '',
      String name = 'Caixa de som',
      String categoryId = 'category-1',
      int totalQuantity = 2,
      EquipmentStatus status = EquipmentStatus.available,
      DateTime? createdAt,
      DateTime? updatedAt,
    }) {
      return Equipment(
        id: id,
        name: name,
        categoryId: categoryId,
        totalQuantity: totalQuantity,
        status: status,
        createdAt: createdAt ?? earlier,
        updatedAt: updatedAt ?? earlier,
      );
    }

    setUp(() async {
      categoryRepository = FakeEquipmentCategoryRepository();
      equipmentRepository = FakeEquipmentRepository();
      await categoryRepository.insert(buildCategory());
    });

    group('create', () {
      test('persists a valid equipment using the injectable clock', () async {
        final service = buildService();

        final result = await service.create(buildDraft());

        expect(result.isSuccess, isTrue);
        expect(result.equipment!.id, isNotEmpty);
        expect(result.equipment!.createdAt, fixedNow);
        expect(result.equipment!.updatedAt, fixedNow);
        expect(result.equipment!.status, EquipmentStatus.available);
        expect(
          await equipmentRepository.findById(result.equipment!.id),
          isNotNull,
        );
      });

      test('rejects invalid name without touching the repository', () async {
        final service = buildService();

        final result = await service.create(buildDraft(name: '  '));

        expect(result.status, EquipmentWriteStatus.validationFailed);
        expect(
          result.errors,
          contains(EquipmentValidator.nameRequiredError),
        );
        expect(await equipmentRepository.listAll(), isEmpty);
      });

      test('rejects quantity less than or equal to zero', () async {
        final service = buildService();

        final result = await service.create(buildDraft(totalQuantity: 0));

        expect(result.status, EquipmentWriteStatus.validationFailed);
        expect(
          result.errors,
          contains(EquipmentValidator.quantityGreaterThanZeroError),
        );
      });

      test('rejects an unknown categoryId', () async {
        final service = buildService();

        final result = await service.create(
          buildDraft(categoryId: 'missing-category'),
        );

        expect(result.status, EquipmentWriteStatus.categoryNotFound);
        expect(await equipmentRepository.listAll(), isEmpty);
      });

      test('rejects an inactive category', () async {
        await categoryRepository.update(
          buildCategory().copyWith(active: false),
        );
        final service = buildService();

        final result = await service.create(buildDraft());

        expect(result.status, EquipmentWriteStatus.categoryInactive);
        expect(await equipmentRepository.listAll(), isEmpty);
      });

      test('returns failure when repository insert throws', () async {
        equipmentRepository.shouldFailOnNextOperation = true;
        final service = buildService();

        final result = await service.create(buildDraft());

        expect(result.status, EquipmentWriteStatus.failure);
      });
    });

    group('update', () {
      test('preserves createdAt and refreshes updatedAt via clock', () async {
        final createResult = await buildService(
          now: earlier,
        ).create(buildDraft());
        final created = createResult.equipment!;
        final later = DateTime(2031, 6, 15, 8);
        final service = buildService(now: later);

        final result = await service.update(
          created.copyWith(name: 'Caixa Pro', totalQuantity: 5),
        );

        expect(result.isSuccess, isTrue);
        expect(result.equipment!.id, created.id);
        expect(result.equipment!.createdAt, earlier);
        expect(result.equipment!.updatedAt, later);
        expect(result.equipment!.name, 'Caixa Pro');
        expect(result.equipment!.totalQuantity, 5);
      });

      test('returns notFound for unknown id', () async {
        final service = buildService();

        final result = await service.update(
          buildDraft(id: 'missing', name: 'Fantasma'),
        );

        expect(result.status, EquipmentWriteStatus.notFound);
      });

      test('rejects inactive category on update', () async {
        final created =
            (await buildService().create(buildDraft())).equipment!;
        await categoryRepository.update(
          buildCategory().copyWith(active: false),
        );

        final result = await buildService().update(
          created.copyWith(name: 'Novo nome'),
        );

        expect(result.status, EquipmentWriteStatus.categoryInactive);
      });
    });

    group('delete', () {
      test('deletes an existing equipment', () async {
        final created =
            (await buildService().create(buildDraft())).equipment!;

        final result = await buildService().delete(created.id);

        expect(result.status, EquipmentDeleteStatus.deleted);
        expect(result.isDeleted, isTrue);
        expect(await equipmentRepository.findById(created.id), isNull);
      });

      test('returns notFound for unknown id', () async {
        final result = await buildService().delete('missing');

        expect(result.status, EquipmentDeleteStatus.notFound);
      });
    });
  });
}
