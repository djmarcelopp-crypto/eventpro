import '../domain/read/assistant_read_planner.dart';
import '../models/assistant_read_filter.dart';
import '../models/assistant_read_intent.dart';
import '../models/assistant_read_pagination.dart';
import '../models/assistant_read_query.dart';
import '../models/assistant_read_sort.dart';
import '../models/assistant_read_status_lexicon.dart';

/// Builds [AssistantReadQuery] from deterministic read intents.
class LocalAssistantReadPlanner implements AssistantReadPlanner {
  const LocalAssistantReadPlanner();

  @override
  AssistantReadQuery plan(
    AssistantReadIntent intent, {
    required String requestId,
    String? queryId,
  }) {
    final id = queryId ?? 'rquery-$requestId';
    return switch (intent) {
      ReadQuoteByIdIntent(:final quoteId) => _query(
          id: id,
          requestId: requestId,
          filters: [
            AssistantReadFilter(field: 'id', operator: 'eq', value: quoteId),
          ],
          limit: 1,
        ),
      ReadQuoteByNumberIntent(:final number) => _query(
          id: id,
          requestId: requestId,
          filters: [
            AssistantReadFilter(
              field: 'number',
              operator: number.contains('ORC-') ? 'eq' : 'contains',
              value: number,
            ),
          ],
          limit: 5,
        ),
      ReadQuoteByCustomerIntent(:final customerName) => _query(
          id: id,
          requestId: requestId,
          filters: [
            AssistantReadFilter(
              field: 'clientDisplayName',
              operator: 'contains',
              value: customerName,
            ),
          ],
          limit: AssistantReadPagination.defaultLimit,
        ),
      ReadRecentQuotesIntent(:final limit) => _query(
          id: id,
          requestId: requestId,
          filters: const [],
          limit: _clampLimit(limit),
        ),
      ReadQuoteSummaryIntent(:final statusToken) => _query(
          id: id,
          requestId: requestId,
          filters: _statusFilters(statusToken),
          limit: AssistantReadPagination.maxLimit,
        ),
      ReadQuotesIntent(:final statusToken, :final limit) => _query(
          id: id,
          requestId: requestId,
          filters: _statusFilters(statusToken),
          limit: _clampLimit(limit ?? AssistantReadPagination.defaultLimit),
        ),
    };
  }

  static AssistantReadQuery _query({
    required String id,
    required String requestId,
    required List<AssistantReadFilter> filters,
    required int limit,
  }) {
    return AssistantReadQuery(
      id: id,
      requestId: requestId,
      module: AssistantReadModules.quote,
      filters: filters,
      sorting: const [
        AssistantReadSort(field: 'createdAt', ascending: false),
      ],
      pagination: AssistantReadPagination(offset: 0, limit: _clampLimit(limit)),
      requiredCapabilities: const {
        AssistantReadCapabilities.structuredQuoteRead,
      },
    );
  }

  static List<AssistantReadFilter> _statusFilters(String? token) {
    if (token == null || token.trim().isEmpty) return const [];
    final statuses = AssistantReadStatusLexicon.resolveStatuses(token);
    if (statuses == null || statuses.isEmpty) return const [];
    if (statuses.length == 1) {
      return [
        AssistantReadFilter(
          field: 'status',
          operator: 'eq',
          value: statuses.single,
        ),
      ];
    }
    return [
      AssistantReadFilter(
        field: 'status',
        operator: 'in',
        value: statuses.join(','),
      ),
    ];
  }

  static int _clampLimit(int limit) {
    if (limit < 1) return 1;
    if (limit > AssistantReadPagination.maxLimit) {
      return AssistantReadPagination.maxLimit;
    }
    return limit;
  }
}
