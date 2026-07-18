import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';

abstract class VehicleMapper {
  static Vehicle toDomain(VehicleRow row) {
    return Vehicle(
      id: row.id,
      plate: row.plate,
      description: row.description,
      vehicleTypeId: row.vehicleTypeId,
      payloadCapacityKg: row.payloadCapacityKg,
      volumeCapacityM3: row.volumeCapacityM3,
      observations: row.observations ?? '',
      status: VehicleStatus.values.byName(row.status),
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static VehiclesCompanion toInsertCompanion(Vehicle vehicle) {
    return _toCompanion(vehicle);
  }

  static VehiclesCompanion toUpdateCompanion(Vehicle vehicle) {
    return _toCompanion(vehicle);
  }

  static VehiclesCompanion _toCompanion(Vehicle vehicle) {
    final observations = vehicle.observations.trim();
    return VehiclesCompanion.insert(
      id: vehicle.id,
      plate: vehicle.plate,
      description: vehicle.description,
      vehicleTypeId: vehicle.vehicleTypeId,
      payloadCapacityKg: vehicle.payloadCapacityKg,
      volumeCapacityM3: vehicle.volumeCapacityM3,
      observations: Value(observations.isEmpty ? null : observations),
      status: vehicle.status.name,
      createdAt: TimestampConverter.toUtcMillis(vehicle.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(vehicle.updatedAt),
    );
  }
}
