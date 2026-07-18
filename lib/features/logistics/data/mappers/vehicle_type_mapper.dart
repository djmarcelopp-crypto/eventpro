import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';

abstract class VehicleTypeMapper {
  static VehicleType toDomain(VehicleTypeRow row) {
    return VehicleType(
      id: row.id,
      name: row.name,
      description: row.description,
      active: row.active,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static VehicleTypesCompanion toInsertCompanion(VehicleType type) {
    return _toCompanion(type);
  }

  static VehicleTypesCompanion toUpdateCompanion(VehicleType type) {
    return _toCompanion(type);
  }

  static VehicleTypesCompanion _toCompanion(VehicleType type) {
    return VehicleTypesCompanion.insert(
      id: type.id,
      name: type.name,
      description: Value(type.description),
      active: type.active,
      createdAt: TimestampConverter.toUtcMillis(type.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(type.updatedAt),
    );
  }
}
