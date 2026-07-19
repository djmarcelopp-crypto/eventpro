import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_read_filter.dart';
import 'package:eventpro/features/assistant/models/assistant_read_pagination.dart';
import 'package:eventpro/features/assistant/models/assistant_read_query.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_read_coordinator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_read_gateway.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_read_adapter.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/utils/quote_query_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import '../../quotes/quotes_test_helpers.dart';

void main() {
  group('AI-008 CP-C/D structured read pipeline', () {
    final now = DateTime.utc(2026, 7, 19, 16);
    late FakeQuoteRepository repository;
    late LocalAssistantReadGateway readGateway;
    late LocalAssistantReadCoordinator coordinator;

    setUp(() async {
      repository = FakeQuoteRepository();
      await repository.insert(
        sampleQuoteDraft(
          id: 'pipe-1',
          status: QuoteStatus.draft,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'pipe-2',
          status: QuoteStatus.sent,
          createdAt: now,
        ),
      );
      readGateway = LocalAssistantReadGateway(
        quoteAdapter: QuoteAssistantReadAdapter(
          QuoteQueryService(repository),
          clock: () => now,
        ),
        clock: () => now,
      );
      coordinator = LocalAssistantReadCoordinator(clock: () => now);
    });

    test('coordinator + gateway retornam lista / vazio / único', () async {
      final caps = AssistantCapabilities.localStructuredQuoteRead();
      final list = await coordinator.execute(
        query: const AssistantReadQuery(
          id: 'rq',
          requestId: 'req',
          module: AssistantReadModules.quote,
          pagination: AssistantReadPagination(limit: 10),
        ),
        capabilities: caps,
        gateway: readGateway,
      );
      expect(list.isMultiple, isTrue);
      expect(list.metadata.pagination.limit, 10);

      final single = await coordinator.execute(
        query: const AssistantReadQuery(
          id: 'rq2',
          requestId: 'req',
          module: AssistantReadModules.quote,
          filters: [
            AssistantReadFilter(field: 'id', operator: 'eq', value: 'pipe-1'),
          ],
        ),
        capabilities: caps,
        gateway: readGateway,
      );
      expect(single.isSingle, isTrue);

      final empty = await coordinator.execute(
        query: const AssistantReadQuery(
          id: 'rq3',
          requestId: 'req',
          module: AssistantReadModules.quote,
          filters: [
            AssistantReadFilter(
              field: 'status',
              operator: 'eq',
              value: 'cancelled',
            ),
          ],
        ),
        capabilities: caps,
        gateway: readGateway,
      );
      expect(empty.isEmpty, isTrue);
    });

    test('capability off / gateway ausente / moduleResults preservados',
        () async {
      final denied = await coordinator.execute(
        query: const AssistantReadQuery(
          id: 'rq',
          requestId: 'req',
          module: AssistantReadModules.quote,
        ),
        capabilities: const AssistantCapabilities(),
        gateway: readGateway,
      );
      expect(denied.valid, isFalse);
      expect(denied.records, isEmpty);

      final orch = LocalAssistantOrchestrator(
        clock: () => now,
        capabilities: AssistantCapabilities.localStructuredQuoteRead(),
        readGateway: readGateway,
      );
      final response = await orch.handle(
        AssistantRequest(
          id: 'req-orch',
          rawText: 'Listar últimos orçamentos',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );
      expect(response.readResult, isNotNull);
      expect(response.readResult!.records, isNotEmpty);
      expect(response.moduleResults, isEmpty);
      expect(response.writeResult?.executed ?? false, isFalse);
      expect(response.friendlyMessage, contains('Leitura estruturada'));
    });

    test('dry path sem capability não consulta ERP', () async {
      final orch = LocalAssistantOrchestrator(clock: () => now);
      final response = await orch.handle(
        AssistantRequest(
          id: 'req-dry',
          rawText: 'Listar últimos orçamentos',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );
      expect(response.readResult, isNull);
      expect(await repository.listAll(), hasLength(2));
    });

    test('paginação inválida é rejeitada na validation', () async {
      final result = await coordinator.execute(
        query: const AssistantReadQuery(
          id: 'rq',
          requestId: 'req',
          module: AssistantReadModules.quote,
          pagination: AssistantReadPagination(limit: 999),
        ),
        capabilities: AssistantCapabilities.localStructuredQuoteRead(),
        gateway: readGateway,
      );
      expect(result.valid, isFalse);
      expect(result.records, isEmpty);
    });
  });
}
