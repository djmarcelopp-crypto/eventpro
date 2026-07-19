import 'assistant_insight_dimension.dart';
import 'assistant_insight_kind.dart';
import 'assistant_insight_metric.dart';

/// One explanatory insight unit (module-agnostic).
class AssistantInsight {
  const AssistantInsight({
    required this.id,
    required this.kind,
    required this.title,
    this.description,
    this.metrics = const [],
    this.dimensions = const [],
    this.attributes = const {},
  });

  final String id;
  final AssistantInsightKind kind;
  final String title;
  final String? description;
  final List<AssistantInsightMetric> metrics;
  final List<AssistantInsightDimension> dimensions;
  final Map<String, Object?> attributes;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'kind': kind.name,
        'title': title,
        'description': description,
        'metrics': metrics.map((m) => m.toDeterministicMap()).toList(),
        'dimensions': dimensions.map((d) => d.toDeterministicMap()).toList(),
        'attributes': attributes,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantInsight &&
            other.id == id &&
            other.kind == kind &&
            other.title == title &&
            other.description == description &&
            _metricsEqual(other.metrics, metrics) &&
            _dimensionsEqual(other.dimensions, dimensions);
  }

  @override
  int get hashCode => Object.hash(
        id,
        kind,
        title,
        description,
        Object.hashAll(metrics),
        Object.hashAll(dimensions),
      );

  static bool _metricsEqual(
    List<AssistantInsightMetric> a,
    List<AssistantInsightMetric> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _dimensionsEqual(
    List<AssistantInsightDimension> a,
    List<AssistantInsightDimension> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
