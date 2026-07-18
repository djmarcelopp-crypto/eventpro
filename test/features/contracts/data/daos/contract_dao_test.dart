import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContractTemplatesDao / ContractsDao', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('contract_dao_test_');
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

    test('DAO CRUD for templates and contracts', () async {
      final templatesDao = database.contractTemplatesDao;
      final contractsDao = database.contractsDao;

      await templatesDao.insertRow(
        ContractTemplatesCompanion.insert(
          id: 'tpl-1',
          name: 'Padrão',
          active: true,
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );

      expect((await templatesDao.getAllOrdered()).single.name, 'Padrão');

      await contractsDao.insertRow(
        ContractsCompanion.insert(
          id: 'ctr-1',
          quoteId: 'quote-1',
          contractNumber: 'CTR-1',
          status: 'draft',
          notes: '',
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );

      expect((await contractsDao.getByQuoteId('quote-1')).single.id, 'ctr-1');
      expect(await contractsDao.deleteById('ctr-1'), isTrue);
      expect(await templatesDao.deleteById('tpl-1'), isTrue);
    });
  });
}
