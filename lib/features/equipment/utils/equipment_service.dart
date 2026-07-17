import 'package:uuid/uuid.dart';

import '../data/repositories/equipment_category_repository.dart';
import '../data/repositories/equipment_repository.dart';
import '../models/equipment.dart';
import '../models/equipment_delete_result.dart';
import '../models/equipment_write_result.dart';
import 'equipment_validator.dart';

/// Coordinates validation and persistence for [Equipment] writes.
///
/// Repositories stay limited to reading/writing rows; every business rule
/// (field validation, category existence/activeness) lives here.
class EquipmentService {
  EquipmentService({
    required EquipmentRepository equipmentRepository,
    required EquipmentCategoryRepository categoryRepository,
    DateTime Function()? clock,
  }) : _equipmentRepository = equipmentRepository,
       _categoryRepository = categoryRepository,
       _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final EquipmentRepository _equipmentRepository;
  final EquipmentCategoryRepository _categoryRepository;

  /// Injectable clock — defaults to [DateTime.now], overridable in tests.
  /// Never call [DateTime.now] directly anywhere else in this class.
  final DateTime Function() _clock;

  Future<EquipmentWriteResult> create(Equipment draft) async {
    final fieldsResult = EquipmentValidator.validate(draft);
    if (!fieldsResult.isValid) {
      return EquipmentWriteResult.validationFailed(fieldsResult.errors);
    }

    final categoryError = await _checkCategory(draft.categoryId);
    if (categoryError != null) {
      return categoryError;
    }

    final now = _clock();
    final equipment = draft.copyWith(
      id: _uuid.v7(),
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _equipmentRepository.insert(equipment);
      return EquipmentWriteResult.success(equipment);
    } catch (_) {
      return EquipmentWriteResult.failure();
    }
  }

  Future<EquipmentWriteResult> update(Equipment equipment) async {
    final existing = await _equipmentRepository.findById(equipment.id);
    if (existing == null) {
      return EquipmentWriteResult.notFound();
    }

    final fieldsResult = EquipmentValidator.validate(equipment);
    if (!fieldsResult.isValid) {
      return EquipmentWriteResult.validationFailed(fieldsResult.errors);
    }

    final categoryError = await _checkCategory(equipment.categoryId);
    if (categoryError != null) {
      return categoryError;
    }

    final now = _clock();
    final normalized = equipment.copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
      updatedAt: now,
    );

    try {
      await _equipmentRepository.update(normalized);
      return EquipmentWriteResult.success(normalized);
    } catch (_) {
      return EquipmentWriteResult.failure();
    }
  }

  Future<EquipmentDeleteResult> delete(String id) async {
    final existing = await _equipmentRepository.findById(id);
    if (existing == null) {
      return const EquipmentDeleteResult(
        status: EquipmentDeleteStatus.notFound,
      );
    }

    try {
      await _equipmentRepository.delete(id);
      return const EquipmentDeleteResult(
        status: EquipmentDeleteStatus.deleted,
      );
    } catch (_) {
      return const EquipmentDeleteResult(
        status: EquipmentDeleteStatus.failure,
      );
    }
  }

  Future<EquipmentWriteResult?> _checkCategory(String categoryId) async {
    final category = await _categoryRepository.findById(categoryId);
    if (category == null) {
      return EquipmentWriteResult.categoryNotFound();
    }
    if (!category.active) {
      return EquipmentWriteResult.categoryInactive();
    }
    return null;
  }
}
