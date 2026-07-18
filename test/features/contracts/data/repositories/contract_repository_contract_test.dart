import 'package:eventpro/features/contracts/data/repositories/contract_repository.dart';
import 'package:eventpro/features/contracts/data/repositories/contract_template_repository.dart';
import 'package:eventpro/features/contracts/models/contract.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/models/contract_template.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/fake_contract_repository.dart';
import '../../fakes/fake_contract_template_repository.dart';

void main() {
  final now = DateTime(2026, 7, 17);

  group('ContractRepository contract', () {
    late ContractRepository repository;

    setUp(() {
      repository = FakeContractRepository();
    });

    test('insert, find, listByQuoteId, update and delete', () async {
      final contract = Contract(
        id: 'ctr-1',
        quoteId: 'quote-1',
        contractNumber: 'CTR-1',
        status: ContractStatus.draft,
        createdAt: now,
        updatedAt: now,
      );

      await repository.insert(contract);
      expect(await repository.findById('ctr-1'), contract);
      expect(await repository.listByQuoteId('quote-1'), [contract]);

      final updated = contract.copyWith(status: ContractStatus.generated);
      await repository.update(updated);
      expect((await repository.findById('ctr-1'))!.status, ContractStatus.generated);

      await repository.delete('ctr-1');
      expect(await repository.listAll(), isEmpty);
    });
  });

  group('ContractTemplateRepository contract', () {
    late ContractTemplateRepository repository;

    setUp(() {
      repository = FakeContractTemplateRepository();
    });

    test('insert, find, update and delete', () async {
      final template = ContractTemplate(
        id: 'tpl-1',
        name: 'Padrão',
        createdAt: now,
        updatedAt: now,
      );

      await repository.insert(template);
      expect(await repository.findById('tpl-1'), template);

      final updated = template.copyWith(active: false);
      await repository.update(updated);
      expect((await repository.findById('tpl-1'))!.active, isFalse);

      await repository.delete('tpl-1');
      expect(await repository.listAll(), isEmpty);
    });
  });
}
