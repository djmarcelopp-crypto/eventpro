import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/contracts/models/contract_template.dart';

abstract class ContractTemplateMapper {
  static ContractTemplate toDomain(ContractTemplateRow row) {
    return ContractTemplate(
      id: row.id,
      name: row.name,
      description: row.description,
      active: row.active,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static ContractTemplatesCompanion toInsertCompanion(ContractTemplate template) {
    return _toCompanion(template);
  }

  static ContractTemplatesCompanion toUpdateCompanion(ContractTemplate template) {
    return _toCompanion(template);
  }

  static ContractTemplatesCompanion _toCompanion(ContractTemplate template) {
    return ContractTemplatesCompanion.insert(
      id: template.id,
      name: template.name,
      description: Value(template.description),
      active: template.active,
      createdAt: TimestampConverter.toUtcMillis(template.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(template.updatedAt),
    );
  }
}
