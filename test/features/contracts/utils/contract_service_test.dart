import 'package:eventpro/features/contracts/models/contract_operation_result.dart';
import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/models/contract_template.dart';
import 'package:eventpro/features/contracts/utils/contract_service.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../fakes/fake_contract_repository.dart';
import '../fakes/fake_contract_template_repository.dart';

void main() {
  group('ContractService', () {
    late FakeContractRepository contractRepository;
    late FakeContractTemplateRepository templateRepository;
    late FakeQuoteRepository quoteRepository;
    late ContractService service;
    final now = DateTime(2026, 7, 17, 12);

    Quote buildQuote({String id = 'quote-1'}) {
      return Quote(
        id: id,
        number: 'ORC-2026-0001',
        status: QuoteStatus.draft,
        clientSnapshot: const QuoteClientSnapshot(
          sourceClientId: 'c1',
          type: QuoteClientType.individual,
          displayName: 'Cliente',
          phone: '67999990000',
        ),
        eventSnapshot: const QuoteEventSnapshot(name: 'Evento'),
        items: const [],
        subtotalCents: 0,
        discountCents: 0,
        freightCents: 0,
        totalCents: 0,
        statusHistory: [
          QuoteStatusHistoryEntry(
            previousStatus: null,
            newStatus: QuoteStatus.draft,
            changedAt: now,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );
    }

    setUp(() async {
      contractRepository = FakeContractRepository();
      templateRepository = FakeContractTemplateRepository(
        initialTemplates: [
          ContractTemplate(
            id: 'tpl-1',
            name: 'Padrão',
            createdAt: now,
            updatedAt: now,
          ),
        ],
      );
      quoteRepository = FakeQuoteRepository(initialQuotes: [buildQuote()]);
      service = ContractService(
        contractRepository: contractRepository,
        templateRepository: templateRepository,
        quoteRepository: quoteRepository,
        clock: () => now,
      );
    });

    test('creates draft contract for existing quote with generated number',
        () async {
      final result = await service.create(quoteId: 'quote-1', templateId: 'tpl-1');
      expect(result.isSuccess, isTrue);
      expect(result.contract!.status, ContractStatus.draft);
      expect(result.contract!.contractNumber, 'CTR-2026-0001');
      expect(result.contract!.createdAt, now);
    });

    test('rejects missing quote and inactive template', () async {
      expect(
        (await service.create(quoteId: 'missing')).status,
        ContractOperationStatus.quoteNotFound,
      );

      await templateRepository.update(
        (await templateRepository.findById('tpl-1'))!.copyWith(active: false),
      );
      expect(
        (await service.create(quoteId: 'quote-1', templateId: 'tpl-1')).status,
        ContractOperationStatus.templateInactive,
      );
    });

    test('apply* persists timestamps and preserves createdAt', () async {
      final created = await service.create(quoteId: 'quote-1');
      final id = created.contract!.id;
      final createdAt = created.contract!.createdAt;

      final generated = await service.applyGenerated(id);
      expect(generated.contract!.status, ContractStatus.generated);
      expect(generated.contract!.generatedAt, now);
      expect(generated.contract!.createdAt, createdAt);

      final sent = await service.applySent(id);
      expect(sent.contract!.status, ContractStatus.sent);
      expect(sent.contract!.sentAt, now);
      expect(sent.contract!.createdAt, createdAt);

      final signed = await service.applySigned(id);
      expect(signed.contract!.status, ContractStatus.signed);
      expect(signed.contract!.signedAt, now);
      expect(signed.contract!.createdAt, createdAt);
    });

    test('apply* returns notFound for missing contract', () async {
      expect(
        (await service.applyGenerated('missing')).status,
        ContractOperationStatus.notFound,
      );
      expect(
        (await service.applyCancelled('missing')).status,
        ContractOperationStatus.notFound,
      );
    });

    test('applyCancelled and applyExpired persist terminal statuses', () async {
      final draft = await service.create(quoteId: 'quote-1');
      final cancelled = await service.applyCancelled(draft.contract!.id);
      expect(cancelled.contract!.status, ContractStatus.cancelled);
      expect(cancelled.contract!.updatedAt, now);

      final second = await service.create(quoteId: 'quote-1');
      await service.applyGenerated(second.contract!.id);
      await service.applySent(second.contract!.id);
      final expired = await service.applyExpired(second.contract!.id);
      expect(expired.contract!.status, ContractStatus.expired);
    });

    test('rejects duplicate contract number', () async {
      await service.create(quoteId: 'quote-1', contractNumber: 'CTR-CUSTOM');
      final duplicate = await service.create(
        quoteId: 'quote-1',
        contractNumber: 'ctr-custom',
      );
      expect(duplicate.status, ContractOperationStatus.duplicateNumber);
    });
  });
}
