import '../../assistant/domain/insight/assistant_insight_adapter.dart';
import '../../assistant/models/assistant_insight_metadata.dart';
import '../../assistant/models/assistant_insight_request.dart';
import '../../assistant/models/assistant_insight_result.dart';
import '../../assistant/models/assistant_module_data_source.dart';
import '../utils/quote_insight_service.dart';

/// ERP quote adapter for the assistant insight gateway.
class QuoteAssistantInsightAdapter implements AssistantInsightAdapter {
  QuoteAssistantInsightAdapter(
    this._service, {
    DateTime Function()? clock,
    this.dataSource = AssistantModuleDataSource.erp,
  }) : _clock = clock ?? DateTime.now;

  final QuoteInsightService _service;
  final DateTime Function() _clock;
  final AssistantModuleDataSource dataSource;

  @override
  String get name => 'QuoteInsightAdapter';

  @override
  String get module => AssistantInsightModules.quote;

  @override
  bool supports(AssistantInsightRequest request) =>
      request.module == AssistantInsightModules.quote &&
      request.requiredCapabilities
          .contains(AssistantInsightCapabilities.quoteInsights);

  @override
  Future<AssistantInsightResult> execute(AssistantInsightRequest request) async {
    final started = _clock();
    final computation = await _service.compute(request);
    final finished = _clock();
    final ms = finished.difference(started).inMilliseconds;

    return AssistantInsightResult(
      requestId: request.requestId,
      insights: computation.insights,
      metrics: computation.metrics,
      dimensions: computation.dimensions,
      warnings: computation.warnings,
      summary: computation.summary,
      metadata: AssistantInsightMetadata(
        timestamp: finished.toUtc(),
        source: dataSource,
        scannedCount: computation.scannedCount,
        maxScan: computation.maxScan,
        scanCapped: computation.scanCapped,
        executionTimeMs: ms < 0 ? 0 : ms,
        module: request.module,
        kind: request.kind.name,
      ),
    );
  }
}
