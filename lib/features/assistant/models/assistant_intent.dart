import 'assistant_confidence.dart';
import 'assistant_intent_type.dart';

/// Classified intent with explainable confidence.
class AssistantIntent {
  const AssistantIntent({
    required this.type,
    required this.confidence,
    this.evidences = const [],
  });

  final AssistantIntentType type;
  final AssistantConfidence confidence;
  final List<String> evidences;

  AssistantIntent copyWith({
    AssistantIntentType? type,
    AssistantConfidence? confidence,
    List<String>? evidences,
  }) {
    return AssistantIntent(
      type: type ?? this.type,
      confidence: confidence ?? this.confidence,
      evidences: evidences ?? this.evidences,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantIntent &&
            other.type == type &&
            other.confidence == confidence &&
            _listEquals(other.evidences, evidences);
  }

  @override
  int get hashCode =>
      Object.hash(type, confidence, Object.hashAll(evidences));

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
