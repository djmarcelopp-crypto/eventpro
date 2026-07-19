import '../domain/read/assistant_read_adapter.dart';
import '../domain/read/assistant_read_gateway.dart';
import '../models/assistant_module_data_source.dart';
import '../models/assistant_read_metadata.dart';
import '../models/assistant_read_query.dart';
import '../models/assistant_read_result.dart';

/// Local composition root for structured reads.
class LocalAssistantReadGateway implements AssistantReadGateway {
  LocalAssistantReadGateway({
    AssistantReadAdapter? quoteAdapter,
    DateTime Function()? clock,
  })  : _quoteAdapter = quoteAdapter,
        _clock = clock ?? DateTime.now;

  final AssistantReadAdapter? _quoteAdapter;
  final DateTime Function() _clock;

  @override
  bool get isAvailable => _quoteAdapter != null;

  @override
  AssistantReadAdapter? adapterFor(String module) {
    if (module == AssistantReadModules.quote) return _quoteAdapter;
    return null;
  }

  @override
  Future<AssistantReadResult> execute(AssistantReadQuery query) async {
    final started = _clock();
    final adapter = adapterFor(query.module);
    if (adapter == null) {
      return AssistantReadResult(
        queryId: query.id,
        module: query.module,
        records: const [],
        valid: false,
        failureMessage: 'Nenhum adapter de leitura para module=${query.module}',
        metadata: AssistantReadMetadata(
          timestamp: started.toUtc(),
          source: AssistantModuleDataSource.test,
          appliedFilters: query.filters,
          pagination: query.pagination.clampToMax(),
          executionTimeMs: 0,
          warnings: const ['Adapter de leitura indisponível'],
        ),
      );
    }
    if (!adapter.supports(query)) {
      final finished = _clock();
      return AssistantReadResult(
        queryId: query.id,
        module: query.module,
        records: const [],
        valid: false,
        failureMessage: 'Adapter ${adapter.name} não suporta a query',
        metadata: AssistantReadMetadata(
          timestamp: finished.toUtc(),
          source: AssistantModuleDataSource.test,
          appliedFilters: query.filters,
          pagination: query.pagination.clampToMax(),
          executionTimeMs: _elapsed(started, finished),
          warnings: const ['Query não suportada pelo adapter'],
        ),
      );
    }
    return adapter.execute(query);
  }

  static int _elapsed(DateTime start, DateTime end) {
    final ms = end.difference(start).inMilliseconds;
    return ms < 0 ? 0 : ms;
  }
}
