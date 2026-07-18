import 'package:uuid/uuid.dart';

import '../data/repositories/vehicle_repository.dart';
import '../data/repositories/vehicle_type_repository.dart';
import '../models/vehicle_type.dart';
import '../models/vehicle_type_operation_result.dart';
import 'vehicle_type_validator.dart';

/// Coordinates validation and persistence for [VehicleType] writes.
class VehicleTypeService {
  VehicleTypeService({
    required this._typeRepository,
    required this._vehicleRepository,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final VehicleTypeRepository _typeRepository;
  final VehicleRepository _vehicleRepository;
  final DateTime Function() _clock;

  Future<VehicleTypeOperationResult> create(VehicleType draft) async {
    final normalizedName = draft.name.trim();
    final fieldsResult =
        VehicleTypeValidator.validateFields(name: normalizedName);
    if (!fieldsResult.isValid) {
      return VehicleTypeOperationResult.validationFailed(fieldsResult.errors);
    }

    if (await _hasDuplicateName(normalizedName)) {
      return VehicleTypeOperationResult.duplicateName();
    }

    final now = _clock();
    final type = draft.copyWith(
      id: _uuid.v7(),
      name: normalizedName,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _typeRepository.insert(type);
      return VehicleTypeOperationResult.success(type);
    } catch (_) {
      return VehicleTypeOperationResult.failure();
    }
  }

  Future<VehicleTypeOperationResult> update(VehicleType type) async {
    final existing = await _typeRepository.findById(type.id);
    if (existing == null) {
      return VehicleTypeOperationResult.notFound();
    }

    final normalizedName = type.name.trim();
    final fieldsResult =
        VehicleTypeValidator.validateFields(name: normalizedName);
    if (!fieldsResult.isValid) {
      return VehicleTypeOperationResult.validationFailed(fieldsResult.errors);
    }

    if (await _hasDuplicateName(normalizedName, excludingId: existing.id)) {
      return VehicleTypeOperationResult.duplicateName();
    }

    final now = _clock();
    final updated = type.copyWith(
      id: existing.id,
      name: normalizedName,
      createdAt: existing.createdAt,
      updatedAt: now,
    );

    try {
      await _typeRepository.update(updated);
      return VehicleTypeOperationResult.success(updated);
    } catch (_) {
      return VehicleTypeOperationResult.failure();
    }
  }

  Future<VehicleTypeOperationResult> activate(String id) async {
    return _setActive(id, active: true);
  }

  Future<VehicleTypeOperationResult> deactivate(String id) async {
    return _setActive(id, active: false);
  }

  Future<VehicleTypeOperationResult> delete(String id) async {
    final existing = await _typeRepository.findById(id);
    if (existing == null) {
      return VehicleTypeOperationResult.notFound();
    }

    final vehicles = await _vehicleRepository.listAll();
    final usageCount =
        vehicles.where((vehicle) => vehicle.vehicleTypeId == id).length;
    if (usageCount > 0) {
      return VehicleTypeOperationResult.blockedByUsage(
        blockingVehicleCount: usageCount,
      );
    }

    try {
      await _typeRepository.delete(id);
      return VehicleTypeOperationResult.deleted();
    } catch (_) {
      return VehicleTypeOperationResult.failure();
    }
  }

  Future<VehicleTypeOperationResult> _setActive(
    String id, {
    required bool active,
  }) async {
    final existing = await _typeRepository.findById(id);
    if (existing == null) {
      return VehicleTypeOperationResult.notFound();
    }

    return update(existing.copyWith(active: active));
  }

  Future<bool> _hasDuplicateName(
    String name, {
    String? excludingId,
  }) async {
    final normalized = name.trim().toLowerCase();
    final types = await _typeRepository.listAll();
    return types.any(
      (type) =>
          type.id != excludingId &&
          type.name.trim().toLowerCase() == normalized,
    );
  }
}
