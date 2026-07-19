import 'assistant_insight.dart';
import 'assistant_insight_dimension.dart';
import 'assistant_insight_metadata.dart';
import 'assistant_insight_metric.dart';
import 'assistant_insight_summary.dart';
import 'assistant_insight_warning.dart';

/// Outcome of a deterministic insight computation.
class AssistantInsightResult {
  const AssistantInsightResult({
    required this.requestId,
    required this.insights,
    required this.metrics,
    required this.dimensions,
    required this.warnings,
    required this.metadata,
    this.summary,
    this.valid = true,
    this.failureMessage,
  });

  final String requestId;
  final List<AssistantInsight> insights;
  final List<AssistantInsightMetric> metrics;
  final List<AssistantInsightDimension> dimensions;
  final List<AssistantInsightWarning> warnings;
  final AssistantInsightMetadata metadata;
  final AssistantInsightSummary? summary;
  final bool valid;
  final String? failureMessage;

  bool get isEmpty =>
      insights.isEmpty && metrics.isEmpty && dimensions.isEmpty;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'valid': valid,
        'failureMessage': failureMessage,
        'summary': summary?.toDeterministicMap(),
        'insights': insights.map((i) => i.toDeterministicMap()).toList(),
        'metrics': metrics.map((m) => m.toDeterministicMap()).toList(),
        'dimensions': dimensions.map((d) => d.toDeterministicMap()).toList(),
        'warnings': warnings.map((w) => w.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
      };
}
