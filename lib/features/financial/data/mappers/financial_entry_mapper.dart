import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/civil_date_converter.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';
import 'package:eventpro/features/financial/models/financial_entry_status.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';

abstract class FinancialEntryMapper {
  static FinancialEntry toDomain(FinancialEntryRow row) {
    return FinancialEntry(
      id: row.id,
      kind: FinancialFlowKind.values.byName(row.kind),
      description: row.description,
      amountCents: row.amountCents,
      date: CivilDateConverter.fromIsoDate(row.date)!,
      categoryId: row.categoryId,
      status: FinancialEntryStatus.values.byName(row.status),
      paidAt: row.paidAt == null
          ? null
          : TimestampConverter.fromUtcMillis(row.paidAt!),
      notes: row.notes,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static FinancialEntriesCompanion toInsertCompanion(FinancialEntry entry) {
    return _toCompanion(entry);
  }

  static FinancialEntriesCompanion toUpdateCompanion(FinancialEntry entry) {
    return _toCompanion(entry);
  }

  static FinancialEntriesCompanion _toCompanion(FinancialEntry entry) {
    return FinancialEntriesCompanion.insert(
      id: entry.id,
      kind: entry.kind.name,
      description: entry.description,
      amountCents: entry.amountCents,
      date: CivilDateConverter.toIsoDate(entry.date)!,
      categoryId: entry.categoryId,
      status: entry.status.name,
      paidAt: Value(
        entry.paidAt == null
            ? null
            : TimestampConverter.toUtcMillis(entry.paidAt!),
      ),
      notes: Value(entry.notes),
      createdAt: TimestampConverter.toUtcMillis(entry.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(entry.updatedAt),
    );
  }
}
