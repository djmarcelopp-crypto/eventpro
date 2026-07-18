import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/contracts/data/repositories/drift_contract_repository.dart';
import 'package:eventpro/features/contracts/data/repositories/drift_contract_template_repository.dart';
import 'package:eventpro/features/contracts/models/contract.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/models/contract_template.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftContract*Repository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftContractTemplateRepository templateRepository;
    late DriftContractRepository contractRepository;
    final now = DateTime(2026, 7, 17, 12);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('contract_repo_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      templateRepository = DriftContractTemplateRepository(database);
      contractRepository = DriftContractRepository(database);
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

    test('persists templates and contracts through repositories', () async {
      final template = ContractTemplate(
        id: 'tpl-1',
        name: 'Padrão',
        createdAt: now,
        updatedAt: now,
      );
      await templateRepository.insert(template);
      expect((await templateRepository.findById('tpl-1'))?.name, 'Padrão');

      final contract = Contract(
        id: 'ctr-1',
        quoteId: 'quote-1',
        templateId: 'tpl-1',
        contractNumber: 'CTR-1',
        status: ContractStatus.draft,
        createdAt: now,
        updatedAt: now,
      );
      await contractRepository.insert(contract);
      expect(await contractRepository.listByQuoteId('quote-1'), [contract]);

      await contractRepository.delete('ctr-1');
      await templateRepository.delete('tpl-1');
      expect(await contractRepository.listAll(), isEmpty);
    });
  });
}
