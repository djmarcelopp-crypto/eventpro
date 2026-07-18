import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/financial/models/financial_category.dart';
import 'package:eventpro/features/financial/models/financial_flow_kind.dart';

abstract class FinancialCategoryMapper {
  static FinancialCategory toDomain(FinancialCategoryRow row) {
    return FinancialCategory(
      id: row.id,
      name: row.name,
      kind: FinancialFlowKind.values.byName(row.kind),
      active: row.active,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
    );
  }

  static FinancialCategoriesCompanion toInsertCompanion(
    FinancialCategory category,
  ) {
    return _toCompanion(category);
  }

  static FinancialCategoriesCompanion toUpdateCompanion(
    FinancialCategory category,
  ) {
    return _toCompanion(category);
  }

  static FinancialCategoriesCompanion _toCompanion(
    FinancialCategory category,
  ) {
    return FinancialCategoriesCompanion.insert(
      id: category.id,
      name: category.name,
      kind: category.kind.name,
      active: category.active,
      createdAt: TimestampConverter.toUtcMillis(category.createdAt),
    );
  }
}
