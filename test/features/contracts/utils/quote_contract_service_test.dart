import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/models/contract_template.dart';
import 'package:eventpro/features/contracts/utils/contract_service.dart';
import 'package:eventpro/features/contracts/utils/contract_workflow_service.dart';
import 'package:eventpro/features/contracts/utils/quote_contract_service.dart';
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
  group('QuoteContractService', () {
    late FakeContractRepository contractRepository;
    late FakeContractTemplateRepository templateRepository;
    late FakeQuoteRepository quoteRepository;
    late QuoteContractService service;
    final now = DateTime(2026, 7, 17, 12);

    Quote buildQuote({String id = 'quote-1'}) {
      return Quote(
        id: id,
        number: 'ORC-2026-0001',
        status: QuoteStatus.approved,
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
            newStatus: QuoteStatus.approved,
            changedAt: now,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );
    }

    setUp(() {
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
      final contractService = ContractService(
        contractRepository: contractRepository,
        templateRepository: templateRepository,
        quoteRepository: quoteRepository,
        clock: () => now,
      );
      final workflowService = ContractWorkflowService(
        contractService: contractService,
        contractRepository: contractRepository,
      );
      service = QuoteContractService(
        contractService: contractService,
        workflowService: workflowService,
      );
    });

    test('generateForQuote creates generated contract and exposes status',
        () async {
      final result = await service.generateForQuote(
        quoteId: 'quote-1',
        templateId: 'tpl-1',
      );
      expect(result.isSuccess, isTrue);
      expect(result.contract!.status, ContractStatus.generated);

      expect(await service.statusForQuote('quote-1'), ContractStatus.generated);

      final summary = await service.summaryForQuote('quote-1');
      expect(summary.contractCount, 1);
      expect(summary.latestStatus, ContractStatus.generated);
      expect(summary.hasSigned, isFalse);
      expect(summary.hasCancellable, isTrue);
    });

    test('cancelContract updates summary status', () async {
      final generated = await service.generateForQuote(quoteId: 'quote-1');
      final cancelled = await service.cancelContract(generated.contract!.id);
      expect(cancelled.contract!.status, ContractStatus.cancelled);

      final summary = await service.summaryForQuote('quote-1');
      expect(summary.latestStatus, ContractStatus.cancelled);
      expect(summary.hasCancellable, isFalse);
    });

    test('empty quote has null status', () async {
      expect(await service.statusForQuote('quote-1'), isNull);
      final summary = await service.summaryForQuote('quote-1');
      expect(summary.hasContracts, isFalse);
    });
  });
}
