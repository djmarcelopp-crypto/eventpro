import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/contracts/models/contract.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';

abstract class ContractMapper {
  static Contract toDomain(ContractRow row) {
    return Contract(
      id: row.id,
      quoteId: row.quoteId,
      templateId: row.templateId,
      contractNumber: row.contractNumber,
      status: ContractStatus.values.byName(row.status),
      generatedAt: row.generatedAt == null
          ? null
          : TimestampConverter.fromUtcMillis(row.generatedAt!),
      sentAt: row.sentAt == null
          ? null
          : TimestampConverter.fromUtcMillis(row.sentAt!),
      signedAt: row.signedAt == null
          ? null
          : TimestampConverter.fromUtcMillis(row.signedAt!),
      expiresAt: row.expiresAt == null
          ? null
          : TimestampConverter.fromUtcMillis(row.expiresAt!),
      filePath: row.filePath,
      notes: row.notes,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static ContractsCompanion toInsertCompanion(Contract contract) {
    return _toCompanion(contract);
  }

  static ContractsCompanion toUpdateCompanion(Contract contract) {
    return _toCompanion(contract);
  }

  static ContractsCompanion _toCompanion(Contract contract) {
    return ContractsCompanion.insert(
      id: contract.id,
      quoteId: contract.quoteId,
      templateId: Value(contract.templateId),
      contractNumber: contract.contractNumber,
      status: contract.status.name,
      generatedAt: Value(
        contract.generatedAt == null
            ? null
            : TimestampConverter.toUtcMillis(contract.generatedAt!),
      ),
      sentAt: Value(
        contract.sentAt == null
            ? null
            : TimestampConverter.toUtcMillis(contract.sentAt!),
      ),
      signedAt: Value(
        contract.signedAt == null
            ? null
            : TimestampConverter.toUtcMillis(contract.signedAt!),
      ),
      expiresAt: Value(
        contract.expiresAt == null
            ? null
            : TimestampConverter.toUtcMillis(contract.expiresAt!),
      ),
      filePath: Value(contract.filePath),
      notes: contract.notes,
      createdAt: TimestampConverter.toUtcMillis(contract.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(contract.updatedAt),
    );
  }
}
