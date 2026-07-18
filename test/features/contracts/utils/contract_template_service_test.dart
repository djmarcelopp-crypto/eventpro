import 'package:eventpro/features/contracts/models/contract.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/models/contract_template.dart';
import 'package:eventpro/features/contracts/models/contract_template_operation_result.dart';
import 'package:eventpro/features/contracts/utils/contract_template_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_contract_repository.dart';
import '../fakes/fake_contract_template_repository.dart';

void main() {
  group('ContractTemplateService', () {
    late FakeContractTemplateRepository templateRepository;
    late FakeContractRepository contractRepository;
    late ContractTemplateService service;
    final now = DateTime(2026, 7, 17, 12);

    setUp(() {
      templateRepository = FakeContractTemplateRepository();
      contractRepository = FakeContractRepository();
      service = ContractTemplateService(
        templateRepository: templateRepository,
        contractRepository: contractRepository,
        clock: () => now,
      );
    });

    test('creates template with normalized name and timestamps', () async {
      final result = await service.create(
        ContractTemplate(
          id: '',
          name: '  Padrão  ',
          createdAt: now,
          updatedAt: now,
        ),
      );

      expect(result.isSuccess, isTrue);
      expect(result.template!.name, 'Padrão');
      expect(result.template!.createdAt, now);
      expect(result.template!.id, isNotEmpty);
    });

    test('rejects duplicate name case-insensitively', () async {
      await service.create(
        ContractTemplate(
          id: '',
          name: 'Padrão',
          createdAt: now,
          updatedAt: now,
        ),
      );
      final result = await service.create(
        ContractTemplate(
          id: '',
          name: 'padrão',
          createdAt: now,
          updatedAt: now,
        ),
      );
      expect(result.status, ContractTemplateOperationStatus.duplicateName);
    });

    test('activate and deactivate update active flag', () async {
      final created = await service.create(
        ContractTemplate(
          id: '',
          name: 'Padrão',
          createdAt: now,
          updatedAt: now,
        ),
      );
      final deactivated = await service.deactivate(created.template!.id);
      expect(deactivated.template!.active, isFalse);
      final activated = await service.activate(created.template!.id);
      expect(activated.template!.active, isTrue);
    });

    test('blocks delete when template is used by a contract', () async {
      final created = await service.create(
        ContractTemplate(
          id: '',
          name: 'Padrão',
          createdAt: now,
          updatedAt: now,
        ),
      );
      await contractRepository.insert(
        Contract(
          id: 'ctr-1',
          quoteId: 'quote-1',
          templateId: created.template!.id,
          contractNumber: 'CTR-1',
          status: ContractStatus.draft,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final result = await service.delete(created.template!.id);
      expect(result.isBlockedByUsage, isTrue);
      expect(result.blockingContractCount, 1);
    });

    test('preserves createdAt on update', () async {
      final created = await service.create(
        ContractTemplate(
          id: '',
          name: 'Padrão',
          createdAt: now,
          updatedAt: now,
        ),
      );
      final later = now.add(const Duration(hours: 1));
      service = ContractTemplateService(
        templateRepository: templateRepository,
        contractRepository: contractRepository,
        clock: () => later,
      );

      final updated = await service.update(
        created.template!.copyWith(name: 'Premium'),
      );
      expect(updated.template!.createdAt, now);
      expect(updated.template!.updatedAt, later);
      expect(updated.template!.name, 'Premium');
    });
  });
}
