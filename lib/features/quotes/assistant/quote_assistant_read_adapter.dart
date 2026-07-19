import '../../assistant/domain/read/assistant_read_adapter.dart';
import '../../assistant/models/assistant_module_data_source.dart';
import '../../assistant/models/assistant_read_filter.dart';
import '../../assistant/models/assistant_read_metadata.dart';
import '../../assistant/models/assistant_read_query.dart';
import '../../assistant/models/assistant_read_record.dart';
import '../../assistant/models/assistant_read_result.dart';
import '../models/quote.dart';
import '../models/quote_status.dart';
import '../utils/quote_query_service.dart';

/// ERP quote read adapter — interprets generic [AssistantReadQuery].
///
/// Lives in the quotes module; depends on assistant contracts only.
class QuoteAssistantReadAdapter implements AssistantReadAdapter {
  QuoteAssistantReadAdapter(
    this._service, {
    DateTime Function()? clock,
    this.dataSource = AssistantModuleDataSource.erp,
  }) : _clock = clock ?? DateTime.now;

  final QuoteQueryService _service;
  final DateTime Function() _clock;
  final AssistantModuleDataSource dataSource;

  @override
  String get name => 'QuoteAssistantReadAdapter';

  @override
  String get module => AssistantReadModules.quote;

  @override
  bool supports(AssistantReadQuery query) {
    return query.module == AssistantReadModules.quote;
  }

  @override
  Future<AssistantReadResult> execute(AssistantReadQuery query) async {
    final started = _clock();
    final pagination = query.pagination.clampToMax();
    final warnings = <String>[];

    final id = _filterValue(query.filters, 'id');
    final number = _filterValue(query.filters, 'number');
    final statusRaw = _filterValue(query.filters, 'status');
    final status = _parseStatus(statusRaw);

    if (statusRaw != null && status == null) {
      warnings.add('status desconhecido ignorado: $statusRaw');
    }

    final sort = query.sorting.isEmpty ? null : query.sorting.first;
    final sortField = sort?.field.trim().isNotEmpty == true
        ? sort!.field.trim()
        : 'createdAt';
    final ascending = sort?.ascending ?? false;

    final page = await _service.query(
      id: id,
      number: number,
      status: status,
      offset: pagination.offset,
      limit: pagination.limit,
      sortField: sortField,
      ascending: ascending,
    );

    if (page.scanCapped) {
      warnings.add(
        'Varredura limitada a ${page.scannedCount} registros (listAll)',
      );
    }

    final records = page.items
        .map((q) => _toRecord(q, query.projection.fields))
        .toList(growable: false);

    final finished = _clock();
    final applied = <AssistantReadFilter>[
      if (id != null)
        AssistantReadFilter(field: 'id', operator: 'eq', value: id),
      if (number != null)
        AssistantReadFilter(field: 'number', operator: 'eq', value: number),
      if (status != null)
        AssistantReadFilter(
          field: 'status',
          operator: 'eq',
          value: status.name,
        ),
    ];

    return AssistantReadResult(
      queryId: query.id,
      module: module,
      records: records,
      metadata: AssistantReadMetadata(
        timestamp: finished.toUtc(),
        source: dataSource,
        appliedFilters: applied,
        pagination: pagination,
        executionTimeMs: _elapsed(started, finished),
        totalMatched: page.totalMatched,
        warnings: warnings,
      ),
    );
  }

  static String? _filterValue(List<AssistantReadFilter> filters, String field) {
    for (final filter in filters) {
      if (filter.field.trim().toLowerCase() != field) continue;
      if (filter.operator.trim().toLowerCase() != 'eq' &&
          filter.operator.trim().toLowerCase() != 'contains') {
        continue;
      }
      final value = filter.value.trim();
      if (value.isEmpty) return null;
      return value;
    }
    return null;
  }

  static QuoteStatus? _parseStatus(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final normalized = raw.trim().toLowerCase();
    for (final status in QuoteStatus.values) {
      if (status.name == normalized) return status;
    }
    return null;
  }

  static AssistantReadRecord _toRecord(Quote quote, List<String> projection) {
    final all = <String, String>{
      'id': quote.id,
      'number': quote.number,
      'status': quote.status.name,
      'clientDisplayName': quote.clientSnapshot.displayName,
      'totalCents': '${quote.totalCents}',
      'createdAt': quote.createdAt.toUtc().toIso8601String(),
      'updatedAt': quote.updatedAt.toUtc().toIso8601String(),
    };
    final fields = projection
        .map((f) => f.trim())
        .where((f) => f.isNotEmpty)
        .toList(growable: false);
    final attributes = fields.isEmpty
        ? all
        : {
            for (final field in fields)
              if (all.containsKey(field)) field: all[field]!,
          };
    return AssistantReadRecord(
      id: quote.id,
      displayName: quote.number,
      attributes: attributes,
    );
  }

  static int _elapsed(DateTime start, DateTime end) {
    final ms = end.difference(start).inMilliseconds;
    return ms < 0 ? 0 : ms;
  }
}
