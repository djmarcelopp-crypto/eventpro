import 'package:eventpro/features/assistant/models/assistant_module_data_source.dart';
import 'package:eventpro/features/assistant/models/assistant_read_filter.dart';
import 'package:eventpro/features/assistant/models/assistant_read_metadata.dart';
import 'package:eventpro/features/assistant/models/assistant_read_pagination.dart';
import 'package:eventpro/features/assistant/models/assistant_read_projection.dart';
import 'package:eventpro/features/assistant/models/assistant_read_query.dart';
import 'package:eventpro/features/assistant/models/assistant_read_record.dart';
import 'package:eventpro/features/assistant/models/assistant_read_result.dart';
import 'package:eventpro/features/assistant/models/assistant_read_sort.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-008 CP-A read contracts', () {
    final ts = DateTime.utc(2026, 7, 19, 14);

    AssistantReadMetadata meta({
      List<String> warnings = const ['z', 'a'],
      int duration = 12,
    }) {
      return AssistantReadMetadata(
        timestamp: ts,
        source: AssistantModuleDataSource.erp,
        appliedFilters: const [
          AssistantReadFilter(field: 'b', operator: 'eq', value: '2'),
          AssistantReadFilter(field: 'a', operator: 'eq', value: '1'),
        ],
        pagination: const AssistantReadPagination(),
        executionTimeMs: duration,
        warnings: warnings,
      );
    }

    test('query/filter/sort/pagination/projection genéricos e determinísticos',
        () {
      const query = AssistantReadQuery(
        id: 'q1',
        requestId: 'r1',
        module: AssistantReadModules.quote,
        filters: [
          AssistantReadFilter(field: 'status', operator: 'eq', value: 'draft'),
        ],
        projection: AssistantReadProjection(fields: ['number', 'status']),
        sorting: [AssistantReadSort(field: 'createdAt', ascending: false)],
        pagination: AssistantReadPagination(offset: 0, limit: 10),
        requiredCapabilities: {AssistantReadCapabilities.structuredQuoteRead},
      );

      expect(query.module, 'quote');
      expect(query.pagination.isValid, isTrue);
      expect(query.toDeterministicMap(), query.toDeterministicMap());
      expect(
        query.toDeterministicMap()['requiredCapabilities'],
        ['structuredQuoteRead'],
      );
    });

    test('pagination clamp e max limit', () {
      expect(
        const AssistantReadPagination(offset: -1, limit: 999).clampToMax(),
        const AssistantReadPagination(offset: 0, limit: 50),
      );
      expect(const AssistantReadPagination(limit: 51).isValid, isFalse);
    });

    test('metadata ordena filtros/warnings; result empty/single/multiple', () {
      expect(meta().toDeterministicMap()['warnings'], ['a', 'z']);
      expect(
        (meta().toDeterministicMap()['appliedFilters'] as List).first['field'],
        'a',
      );
      expect(meta(duration: -5).toDeterministicMap()['executionTimeMs'], 0);

      final empty = AssistantReadResult(
        queryId: 'q',
        module: 'quote',
        records: const [],
        metadata: meta(),
      );
      final single = AssistantReadResult(
        queryId: 'q',
        module: 'quote',
        records: const [
          AssistantReadRecord(id: '1', displayName: 'ORC-1'),
        ],
        metadata: meta(),
      );
      final multiple = AssistantReadResult(
        queryId: 'q',
        module: 'quote',
        records: const [
          AssistantReadRecord(id: '1', displayName: 'ORC-1'),
          AssistantReadRecord(id: '2', displayName: 'ORC-2'),
        ],
        metadata: meta(),
      );

      expect(empty.isEmpty, isTrue);
      expect(single.isSingle, isTrue);
      expect(multiple.isMultiple, isTrue);
      expect(single.toDeterministicMap(), single.toDeterministicMap());
    });
  });
}
