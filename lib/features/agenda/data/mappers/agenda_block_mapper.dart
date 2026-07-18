import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';

abstract class AgendaBlockMapper {
  static AgendaBlock toDomain(AgendaBlockRow row) {
    return AgendaBlock(
      id: row.id,
      title: row.title,
      notes: row.notes,
      start: TimestampConverter.fromUtcMillis(row.start),
      end: TimestampConverter.fromUtcMillis(row.end),
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static AgendaBlocksCompanion toInsertCompanion(AgendaBlock block) {
    return _toCompanion(block);
  }

  static AgendaBlocksCompanion toUpdateCompanion(AgendaBlock block) {
    return _toCompanion(block);
  }

  static AgendaBlocksCompanion _toCompanion(AgendaBlock block) {
    return AgendaBlocksCompanion.insert(
      id: block.id,
      title: block.title,
      notes: Value(block.notes),
      start: TimestampConverter.toUtcMillis(block.start),
      end: TimestampConverter.toUtcMillis(block.end),
      createdAt: TimestampConverter.toUtcMillis(block.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(block.updatedAt),
    );
  }
}
