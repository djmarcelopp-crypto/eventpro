import 'package:uuid/uuid.dart';

import '../data/repositories/vehicle_repository.dart';
import '../data/repositories/vehicle_type_repository.dart';
import '../models/vehicle.dart';
import '../models/vehicle_operation_result.dart';
import 'vehicle_validator.dart';

/// Coordinates validation and persistence for [Vehicle] writes.
///
/// Plate uniqueness is case-insensitive after trim + uppercase normalization.
class VehicleService {
  VehicleService({
    required this._vehicleRepository,
    required this._typeRepository,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final VehicleRepository _vehicleRepository;
  final VehicleTypeRepository _typeRepository;
  final DateTime Function() _clock;

  /// Normalizes a plate for storage and uniqueness checks.
  static String normalizePlate(String plate) => plate.trim().toUpperCase();

  Future<VehicleOperationResult> create(Vehicle draft) async {
    final normalizedPlate = normalizePlate(draft.plate);
    final fieldsResult = VehicleValidator.validateFields(
      plate: normalizedPlate,
      vehicleTypeId: draft.vehicleTypeId,
      payloadCapacityKg: draft.payloadCapacityKg,
      volumeCapacityM3: draft.volumeCapacityM3,
      status: draft.status,
    );
    if (!fieldsResult.isValid) {
      return VehicleOperationResult.validationFailed(fieldsResult.errors);
    }

    final typeError = await _checkType(draft.vehicleTypeId);
    if (typeError != null) {
      return typeError;
    }

    if (await _hasDuplicatePlate(normalizedPlate)) {
      return VehicleOperationResult.duplicatePlate();
    }

    final now = _clock();
    final vehicle = draft.copyWith(
      id: _uuid.v7(),
      plate: normalizedPlate,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _vehicleRepository.insert(vehicle);
      return VehicleOperationResult.success(vehicle);
    } catch (_) {
      return VehicleOperationResult.failure();
    }
  }

  Future<VehicleOperationResult> update(Vehicle vehicle) async {
    final existing = await _vehicleRepository.findById(vehicle.id);
    if (existing == null) {
      return VehicleOperationResult.notFound();
    }

    final normalizedPlate = normalizePlate(vehicle.plate);
    final fieldsResult = VehicleValidator.validateFields(
      plate: normalizedPlate,
      vehicleTypeId: vehicle.vehicleTypeId,
      payloadCapacityKg: vehicle.payloadCapacityKg,
      volumeCapacityM3: vehicle.volumeCapacityM3,
      status: vehicle.status,
    );
    if (!fieldsResult.isValid) {
      return VehicleOperationResult.validationFailed(fieldsResult.errors);
    }

    final typeError = await _checkType(vehicle.vehicleTypeId);
    if (typeError != null) {
      return typeError;
    }

    if (await _hasDuplicatePlate(normalizedPlate, excludingId: existing.id)) {
      return VehicleOperationResult.duplicatePlate();
    }

    final now = _clock();
    final normalized = vehicle.copyWith(
      id: existing.id,
      plate: normalizedPlate,
      createdAt: existing.createdAt,
      updatedAt: now,
    );

    try {
      await _vehicleRepository.update(normalized);
      return VehicleOperationResult.success(normalized);
    } catch (_) {
      return VehicleOperationResult.failure();
    }
  }

  Future<VehicleOperationResult> delete(String id) async {
    final existing = await _vehicleRepository.findById(id);
    if (existing == null) {
      return VehicleOperationResult.notFound();
    }

    try {
      await _vehicleRepository.delete(id);
      return VehicleOperationResult.deleted();
    } catch (_) {
      return VehicleOperationResult.failure();
    }
  }

  Future<VehicleOperationResult?> _checkType(String typeId) async {
    final type = await _typeRepository.findById(typeId);
    if (type == null) {
      return VehicleOperationResult.typeNotFound();
    }
    if (!type.active) {
      return VehicleOperationResult.typeInactive();
    }
    return null;
  }

  Future<bool> _hasDuplicatePlate(
    String normalizedPlate, {
    String? excludingId,
  }) async {
    final vehicles = await _vehicleRepository.listAll();
    return vehicles.any(
      (vehicle) =>
          vehicle.id != excludingId &&
          normalizePlate(vehicle.plate) == normalizedPlate,
    );
  }
}
