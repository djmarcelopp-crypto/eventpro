import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/equipment/models/quote_equipment.dart';

abstract class QuoteEquipmentMapper {
  static QuoteEquipment toDomain(QuoteEquipmentRow row) {
    return QuoteEquipment(
      id: row.id,
      quoteId: row.quoteId,
      equipmentId: row.equipmentId,
      quantity: row.quantity,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static QuoteEquipmentItemsCompanion toInsertCompanion(QuoteEquipment item) {
    return _toCompanion(item);
  }

  static QuoteEquipmentItemsCompanion toUpdateCompanion(QuoteEquipment item) {
    return _toCompanion(item);
  }

  static QuoteEquipmentItemsCompanion _toCompanion(QuoteEquipment item) {
    return QuoteEquipmentItemsCompanion.insert(
      id: item.id,
      quoteId: item.quoteId,
      equipmentId: item.equipmentId,
      quantity: item.quantity,
      createdAt: TimestampConverter.toUtcMillis(item.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(item.updatedAt),
    );
  }
}
