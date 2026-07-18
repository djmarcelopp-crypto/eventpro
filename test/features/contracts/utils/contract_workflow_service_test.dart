import 'package:eventpro/features/contracts/models/contract_status.dart';
import 'package:eventpro/features/contracts/utils/contract_service.dart';
import 'package:eventpro/features/contracts/utils/contract_workflow_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../contracts_test_helpers.dart';
import '../fakes/fake_contract_repository.dart';
import '../fakes/fake_contract_template_repository.dart';
import '../../quotes/fakes/fake_quote_repository.dart';

void main() {
  late FakeContractRepository contractRepository;
  late FakeContractTemplateRepository templateRepository;
  late FakeQuoteRepository quoteRepository;
  late ContractService contractService;
  late ContractWorkflowService workflow;
  final now = DateTime(2026, 7, 17, 12);

  setUp(() {
    contractRepository = FakeContractRepository();
    templateRepository = FakeContractTemplateRepository(
      initialTemplates: [buildTestTemplate()],
    );
    quoteRepository = FakeQuoteRepository(initialQuotes: [buildTestQuote()]);
    contractService = ContractService(
      contractRepository: contractRepository,
      templateRepository: templateRepository,
      quoteRepository: quoteRepository,
      clock: () => now,
    );
    workflow = ContractWorkflowService(
      contractService: contractService,
      contractRepository: contractRepository,
    );
  });

  group('canTransition matrix', () {
    test('allows happy path draft → generated → sent → signed', () {
      expect(
        workflow.canTransition(ContractStatus.draft, ContractStatus.generated),
        isTrue,
      );
      expect(
        workflow.canTransition(ContractStatus.generated, ContractStatus.sent),
        isTrue,
      );
      expect(
        workflow.canTransition(ContractStatus.sent, ContractStatus.signed),
        isTrue,
      );
    });

    test('allows cancel from draft/generated/sent only', () {
      expect(
        workflow.canTransition(ContractStatus.draft, ContractStatus.cancelled),
        isTrue,
      );
      expect(
        workflow.canTransition(
          ContractStatus.generated,
          ContractStatus.cancelled,
        ),
        isTrue,
      );
      expect(
        workflow.canTransition(ContractStatus.sent, ContractStatus.cancelled),
        isTrue,
      );
      expect(
        workflow.canTransition(ContractStatus.signed, ContractStatus.cancelled),
        isFalse,
      );
      expect(
        workflow.canTransition(
          ContractStatus.expired,
          ContractStatus.cancelled,
        ),
        isFalse,
      );
    });

    test('allows expire from generated/sent but never from signed', () {
      expect(
        workflow.canTransition(ContractStatus.generated, ContractStatus.expired),
        isTrue,
      );
      expect(
        workflow.canTransition(ContractStatus.sent, ContractStatus.expired),
        isTrue,
      );
      expect(
        workflow.canTransition(ContractStatus.signed, ContractStatus.expired),
        isFalse,
      );
      expect(
        workflow.canTransition(ContractStatus.draft, ContractStatus.expired),
        isFalse,
      );
    });

    test('blocks signature after cancellation', () {
      expect(
        workflow.canTransition(
          ContractStatus.cancelled,
          ContractStatus.signed,
        ),
        isFalse,
      );
    });

    test('blocks status regression on happy path', () {
      expect(
        workflow.wouldRegress(ContractStatus.sent, ContractStatus.generated),
        isTrue,
      );
      expect(
        workflow.canTransition(ContractStatus.sent, ContractStatus.generated),
        isFalse,
      );
      expect(
        workflow.canTransition(ContractStatus.signed, ContractStatus.sent),
        isFalse,
      );
      expect(
        workflow.canTransition(ContractStatus.generated, ContractStatus.draft),
        isFalse,
      );
    });
  });

  group('advance persistence', () {
    Future<String> seed({
      ContractStatus status = ContractStatus.draft,
    }) async {
      final created = await contractService.create(quoteId: 'quote-1');
      expect(created.isSuccess, isTrue);
      final id = created.contract!.id;

      switch (status) {
        case ContractStatus.draft:
          break;
        case ContractStatus.generated:
          expect((await workflow.generate(id)).isSuccess, isTrue);
        case ContractStatus.sent:
          expect((await workflow.generate(id)).isSuccess, isTrue);
          expect((await workflow.markSent(id)).isSuccess, isTrue);
        case ContractStatus.signed:
          expect((await workflow.generate(id)).isSuccess, isTrue);
          expect((await workflow.markSent(id)).isSuccess, isTrue);
          expect((await workflow.markSigned(id)).isSuccess, isTrue);
        case ContractStatus.cancelled:
          expect((await workflow.generate(id)).isSuccess, isTrue);
          expect((await workflow.cancel(id)).isSuccess, isTrue);
        case ContractStatus.expired:
          expect((await workflow.generate(id)).isSuccess, isTrue);
          expect((await workflow.markExpired(id)).isSuccess, isTrue);
      }
      return id;
    }

    test('executes full happy path', () async {
      final id = await seed();
      expect((await workflow.generate(id)).contract!.status,
          ContractStatus.generated);
      expect((await workflow.markSent(id)).contract!.status, ContractStatus.sent);
      expect(
        (await workflow.markSigned(id)).contract!.status,
        ContractStatus.signed,
      );
    });

    test('cannot cancel after signature', () async {
      final id = await seed(status: ContractStatus.signed);
      final result = await workflow.cancel(id);
      expect(result.isSuccess, isFalse);
      expect(result.status.name, 'cannotCancelSigned');
    });

    test('cannot sign after cancellation', () async {
      final id = await seed(status: ContractStatus.cancelled);
      final result = await workflow.markSigned(id);
      expect(result.isSuccess, isFalse);
      expect(result.status.name, 'cannotSignCancelled');
    });

    test('cannot expire a signed contract', () async {
      final id = await seed(status: ContractStatus.signed);
      final result = await workflow.markExpired(id);
      expect(result.isSuccess, isFalse);
      expect(result.status.name, 'invalidTransition');
    });

    test('cannot regress from sent to generated', () async {
      final id = await seed(status: ContractStatus.sent);
      final result = await workflow.advance(id, ContractStatus.generated);
      expect(result.isSuccess, isFalse);
      expect(result.status.name, 'invalidTransition');
    });

    test('summarize reflects allowed next statuses', () async {
      final id = await seed(status: ContractStatus.generated);
      final summary = await workflow.summarizeById(id);
      expect(summary, isNotNull);
      expect(summary!.canMarkSent, isTrue);
      expect(summary.canCancel, isTrue);
      expect(summary.canExpire, isTrue);
      expect(summary.canSign, isFalse);
      expect(summary.canGenerate, isFalse);
      expect(summary.isTerminal, isFalse);
    });
  });
}
