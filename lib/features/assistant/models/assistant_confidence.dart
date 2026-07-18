import 'assistant_confidence_level.dart';

/// Structured, explainable confidence — never a bare opaque double.
class AssistantConfidence {
  const AssistantConfidence({
    required this.score,
    required this.level,
    this.reasons = const [],
    this.evidences = const [],
  });

  /// Deterministic score in `[0.0, 1.0]`.
  final double score;
  final AssistantConfidenceLevel level;
  final List<String> reasons;
  final List<String> evidences;

  factory AssistantConfidence.fromScore(
    double score, {
    List<String> reasons = const [],
    List<String> evidences = const [],
  }) {
    final clamped = score.clamp(0.0, 1.0).toDouble();
    final level = clamped >= 0.75
        ? AssistantConfidenceLevel.high
        : clamped >= 0.45
            ? AssistantConfidenceLevel.medium
            : AssistantConfidenceLevel.low;
    return AssistantConfidence(
      score: clamped,
      level: level,
      reasons: List.unmodifiable(reasons),
      evidences: List.unmodifiable(evidences),
    );
  }

  static const none = AssistantConfidence(
    score: 0,
    level: AssistantConfidenceLevel.low,
    reasons: ['Sem evidências suficientes'],
  );

  AssistantConfidence copyWith({
    double? score,
    AssistantConfidenceLevel? level,
    List<String>? reasons,
    List<String>? evidences,
  }) {
    return AssistantConfidence(
      score: score ?? this.score,
      level: level ?? this.level,
      reasons: reasons ?? this.reasons,
      evidences: evidences ?? this.evidences,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantConfidence &&
            other.score == score &&
            other.level == level &&
            _listEquals(other.reasons, reasons) &&
            _listEquals(other.evidences, evidences);
  }

  @override
  int get hashCode => Object.hash(
        score,
        level,
        Object.hashAll(reasons),
        Object.hashAll(evidences),
      );
}

bool _listEquals<T>(List<T> a, List<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
