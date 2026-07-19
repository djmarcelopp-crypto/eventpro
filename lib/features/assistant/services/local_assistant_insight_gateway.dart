import '../domain/insight/assistant_insight_adapter.dart';
import '../domain/insight/assistant_insight_gateway.dart';
import '../models/assistant_insight_metadata.dart';
import '../models/assistant_insight_request.dart';
import '../models/assistant_insight_result.dart';
import '../models/assistant_module_data_source.dart';

/// Local composition root for insight adapters.
class LocalAssistantInsightGateway implements AssistantInsightGateway {
  LocalAssistantInsightGateway({
    AssistantInsightAdapter? quoteAdapter,
    DateTime Function()? clock,
  })  : _quoteAdapter = quoteAdapter,
        _clock = clock ?? DateTime.now;

  final AssistantInsightAdapter? _quoteAdapter;
  final DateTime Function() _clock;

  @override
  bool get isAvailable => _quoteAdapter != null;

  @override
  AssistantInsightAdapter? adapterFor(String module) {
    if (module == AssistantInsightModules.quote) return _quoteAdapter;
    return null;
  }

  @override
  Future<AssistantInsightResult> execute(AssistantInsightRequest request) async {
    final started = _clock();
    final adapter = adapterFor(request.module);
    if (adapter == null) {
      return AssistantInsightResult(
        requestId: request.requestId,
        insights: const [],
        metrics: const [],
        dimensions: const [],
        warnings: const [],
        valid: false,
        failureMessage:
            'Nenhum adapter de insight para module=${request.module}',
        metadata: AssistantInsightMetadata(
          timestamp: started.toUtc(),
          source: AssistantModuleDataSource.test,
          scannedCount: 0,
          maxScan: 0,
          scanCapped: false,
          module: request.module,
          kind: request.kind.name,
        ),
      );
    }
    if (!adapter.supports(request)) {
      final finished = _clock();
      return AssistantInsightResult(
        requestId: request.requestId,
        insights: const [],
        metrics: const [],
        dimensions: const [],
        warnings: const [],
        valid: false,
        failureMessage: 'Adapter ${adapter.name} não suporta o insight',
        metadata: AssistantInsightMetadata(
          timestamp: finished.toUtc(),
          source: AssistantModuleDataSource.test,
          scannedCount: 0,
          maxScan: 0,
          scanCapped: false,
          executionTimeMs: _elapsed(started, finished),
          module: request.module,
          kind: request.kind.name,
        ),
      );
    }
    return adapter.execute(request);
  }

  static int _elapsed(DateTime start, DateTime end) {
    final ms = end.difference(start).inMilliseconds;
    return ms < 0 ? 0 : ms;
  }
}
