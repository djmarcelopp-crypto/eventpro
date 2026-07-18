import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/contracts/data/mappers/contract_mapper.dart';
import 'package:eventpro/features/contracts/data/mappers/contract_template_mapper.dart';
import 'package:eventpro/features/contracts/models/contract.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/models/contract_template.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContractMapper / ContractTemplateMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 7, 17, 12);
    final updatedAt = DateTime(2026, 7, 17, 15);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('contract_mapper_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      await database.into(database.quotes).insert(
            QuotesCompanion.insert(
              id: 'quote-1',
              number: 'ORC-1',
              status: 'draft',
              subtotalCents: 0,
              discountCents: 0,
              freightCents: 0,
              totalCents: 0,
              createdAt: 1_700_000_000_000,
              updatedAt: 1_700_000_000_000,
            ),
          );
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('ContractTemplateMapper round-trips fields', () async {
      final original = ContractTemplate(
        id: 'tpl-1',
        name: 'Padrão',
        description: 'Desc',
        active: false,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      await database.into(database.contractTemplates).insert(
            ContractTemplateMapper.toInsertCompanion(original),
          );
      final row = await (database.select(database.contractTemplates)
            ..where((tbl) => tbl.id.equals('tpl-1')))
          .getSingle();
      expect(ContractTemplateMapper.toDomain(row), original);
    });

    test('ContractMapper round-trips fields including nullable timestamps',
        () async {
      await database.into(database.contractTemplates).insert(
            ContractTemplateMapper.toInsertCompanion(
              ContractTemplate(
                id: 'tpl-1',
                name: 'Padrão',
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
            ),
          );

      final original = Contract(
        id: 'ctr-1',
        quoteId: 'quote-1',
        templateId: 'tpl-1',
        contractNumber: 'CTR-1',
        status: ContractStatus.generated,
        generatedAt: createdAt,
        notes: 'ok',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      await database
          .into(database.contracts)
          .insert(ContractMapper.toInsertCompanion(original));
      final row = await (database.select(database.contracts)
            ..where((tbl) => tbl.id.equals('ctr-1')))
          .getSingle();
      expect(ContractMapper.toDomain(row), original);
    });
  });
}
