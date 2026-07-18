import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/equipment/models/equipment.dart';
import 'package:eventpro/features/equipment/models/equipment_status.dart';

abstract class EquipmentMapper {
  static Equipment toDomain(EquipmentRow row) {
    return Equipment(
      id: row.id,
      name: row.name,
      description: row.description,
      categoryId: row.categoryId,
      serialNumber: row.serialNumber,
      totalQuantity: row.totalQuantity,
      status: EquipmentStatus.values.byName(row.status),
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static EquipmentsCompanion toInsertCompanion(Equipment equipment) {
    return _toCompanion(equipment);
  }

  static EquipmentsCompanion toUpdateCompanion(Equipment equipment) {
    return _toCompanion(equipment);
  }

  static EquipmentsCompanion _toCompanion(Equipment equipment) {
    return EquipmentsCompanion.insert(
      id: equipment.id,
      name: equipment.name,
      description: equipment.description,
      categoryId: equipment.categoryId,
      serialNumber: Value(equipment.serialNumber),
      totalQuantity: equipment.totalQuantity,
      status: equipment.status.name,
      createdAt: TimestampConverter.toUtcMillis(equipment.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(equipment.updatedAt),
    );
  }
}
