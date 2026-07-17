import 'package:uuid/uuid.dart';

import '../data/repositories/equipment_category_repository.dart';
import '../data/repositories/equipment_repository.dart';
import '../models/equipment_category.dart';
import '../models/equipment_category_delete_result.dart';
import '../models/equipment_category_write_result.dart';
import 'equipment_category_validator.dart';

/// Coordinates validation and persistence for [EquipmentCategory] writes.
///
/// Repositories stay limited to reading/writing rows; every business rule
/// (field validation, "category in use" check on delete, deactivation via
/// update) lives here.
class EquipmentCategoryService {
  EquipmentCategoryService({
    required EquipmentCategoryRepository categoryRepository,
    required EquipmentRepository equipmentRepository,
    DateTime Function()? clock,
  }) : _categoryRepository = categoryRepository,
       _equipmentRepository = equipmentRepository,
       _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final EquipmentCategoryRepository _categoryRepository;
  final EquipmentRepository _equipmentRepository;

  /// Injectable clock — defaults to [DateTime.now], overridable in tests.
  /// Never call [DateTime.now] directly anywhere else in this class.
  final DateTime Function() _clock;

  Future<EquipmentCategoryWriteResult> create(
    EquipmentCategory draft,
  ) async {
    final fieldsResult = EquipmentCategoryValidator.validate(draft);
    if (!fieldsResult.isValid) {
      return EquipmentCategoryWriteResult.validationFailed(
        fieldsResult.errors,
      );
    }

    final now = _clock();
    final category = draft.copyWith(
      id: _uuid.v7(),
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _categoryRepository.insert(category);
      return EquipmentCategoryWriteResult.success(category);
    } catch (_) {
      return EquipmentCategoryWriteResult.failure();
    }
  }

  Future<EquipmentCategoryWriteResult> update(
    EquipmentCategory category,
  ) async {
    final existing = await _categoryRepository.findById(category.id);
    if (existing == null) {
      return EquipmentCategoryWriteResult.notFound();
    }

    final fieldsResult = EquipmentCategoryValidator.validate(category);
    if (!fieldsResult.isValid) {
      return EquipmentCategoryWriteResult.validationFailed(
        fieldsResult.errors,
      );
    }

    final now = _clock();
    final updated = category.copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
      updatedAt: now,
    );

    try {
      await _categoryRepository.update(updated);
      return EquipmentCategoryWriteResult.success(updated);
    } catch (_) {
      return EquipmentCategoryWriteResult.failure();
    }
  }

  Future<EquipmentCategoryDeleteResult> delete(String id) async {
    final existing = await _categoryRepository.findById(id);
    if (existing == null) {
      return const EquipmentCategoryDeleteResult(
        status: EquipmentCategoryDeleteStatus.notFound,
      );
    }

    final equipment = await _equipmentRepository.listAll();
    final usageCount =
        equipment.where((item) => item.categoryId == id).length;
    if (usageCount > 0) {
      return EquipmentCategoryDeleteResult(
        status: EquipmentCategoryDeleteStatus.blockedByUsage,
        blockingEquipmentCount: usageCount,
      );
    }

    try {
      await _categoryRepository.delete(id);
      return const EquipmentCategoryDeleteResult(
        status: EquipmentCategoryDeleteStatus.deleted,
      );
    } catch (_) {
      return const EquipmentCategoryDeleteResult(
        status: EquipmentCategoryDeleteStatus.failure,
      );
    }
  }
}
