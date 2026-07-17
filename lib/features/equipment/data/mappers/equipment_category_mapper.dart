import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/equipment/models/equipment_category.dart';

abstract class EquipmentCategoryMapper {
  static EquipmentCategory toDomain(EquipmentCategoryRow row) {
    return EquipmentCategory(
      id: row.id,
      name: row.name,
      description: row.description,
      active: row.active,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static EquipmentCategoriesCompanion toInsertCompanion(
    EquipmentCategory category,
  ) {
    return _toCompanion(category);
  }

  static EquipmentCategoriesCompanion toUpdateCompanion(
    EquipmentCategory category,
  ) {
    return _toCompanion(category);
  }

  static EquipmentCategoriesCompanion _toCompanion(
    EquipmentCategory category,
  ) {
    return EquipmentCategoriesCompanion.insert(
      id: category.id,
      name: category.name,
      description: Value(category.description),
      active: category.active,
      createdAt: TimestampConverter.toUtcMillis(category.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(category.updatedAt),
    );
  }
}
