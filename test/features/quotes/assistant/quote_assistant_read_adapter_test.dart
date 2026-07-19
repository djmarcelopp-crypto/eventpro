import 'package:eventpro/features/assistant/models/assistant_module_data_source.dart';
import 'package:eventpro/features/assistant/models/assistant_read_filter.dart';
import 'package:eventpro/features/assistant/models/assistant_read_pagination.dart';
import 'package:eventpro/features/assistant/models/assistant_read_query.dart';
import 'package:eventpro/features/assistant/models/assistant_read_sort.dart';
import 'package:eventpro/features/quotes/assistant/quote_assistant_read_adapter.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/utils/quote_query_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_quote_repository.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('AI-008 CP-B QuoteAssistantReadAdapter', () {
    final now = DateTime.utc(2026, 7, 19, 15);
    late FakeQuoteRepository repository;
    late QuoteAssistantReadAdapter adapter;

    setUp(() async {
      repository = FakeQuoteRepository();
      adapter = QuoteAssistantReadAdapter(
        QuoteQueryService(repository),
        clock: () => now,
        dataSource: AssistantModuleDataSource.test,
      );

      await repository.insert(
        sampleQuoteDraft(
          id: 'q-draft',
          status: QuoteStatus.draft,
          createdAt: DateTime(2026, 7, 1),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'q-sent',
          status: QuoteStatus.sent,
          createdAt: DateTime(2026, 7, 2),
        ),
      );
      await repository.insert(
        sampleQuoteDraft(
          id: 'q-old',
          status: QuoteStatus.approved,
          createdAt: DateTime(2026, 6, 1),
        ),
      );
    });

    AssistantReadQuery query({
      List<AssistantReadFilter> filters = const [],
      int limit = 10,
      int offset = 0,
      bool ascending = false,
    }) {
      return AssistantReadQuery(
        id: 'rq-1',
        requestId: 'req-1',
        module: AssistantReadModules.quote,
        filters: filters,
        sorting: [
          AssistantReadSort(field: 'createdAt', ascending: ascending),
        ],
        pagination: AssistantReadPagination(offset: offset, limit: limit),
      );
    }

    test('por id / por número / por status / recentes paginados', () async {
      final byId = await adapter.execute(
        query(
          filters: const [
            AssistantReadFilter(field: 'id', operator: 'eq', value: 'q-sent'),
          ],
        ),
      );
      expect(byId.isSingle, isTrue);
      expect(byId.records.single.id, 'q-sent');

      final all = await repository.listAll();
      final number = all.firstWhere((q) => q.id == 'q-draft').number;
      final byNumber = await adapter.execute(
        query(
          filters: [
            AssistantReadFilter(field: 'number', operator: 'eq', value: number),
          ],
        ),
      );
      expect(byNumber.isSingle, isTrue);
      expect(byNumber.records.single.id, 'q-draft');

      final byStatus = await adapter.execute(
        query(
          filters: const [
            AssistantReadFilter(
              field: 'status',
              operator: 'eq',
              value: 'draft',
            ),
          ],
        ),
      );
      expect(byStatus.records.every((r) => r.attributes['status'] == 'draft'),
          isTrue);

      final recent = await adapter.execute(query(limit: 2));
      expect(recent.records, hasLength(2));
      expect(recent.records.first.id, 'q-sent');
      expect(recent.metadata.pagination.limit, 2);
      expect(recent.metadata.source, AssistantModuleDataSource.test);
    });

    test('resultado vazio e paginação obrigatória', () async {
      final empty = await adapter.execute(
        query(
          filters: const [
            AssistantReadFilter(
              field: 'id',
              operator: 'eq',
              value: 'missing',
            ),
          ],
        ),
      );
      expect(empty.isEmpty, isTrue);

      final page = await adapter.execute(query(offset: 1, limit: 1));
      expect(page.records, hasLength(1));
      expect(page.metadata.totalMatched, 3);
    });
  });
}
