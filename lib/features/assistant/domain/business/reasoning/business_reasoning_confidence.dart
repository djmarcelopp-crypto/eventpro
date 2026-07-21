/// Deterministic confidence for a business reasoning decision (AI-023).
enum BusinessReasoningConfidence {
  none,
  low,
  medium,
  high,
  certain,
}

extension BusinessReasoningConfidenceX on BusinessReasoningConfidence {
  double get score => switch (this) {
        BusinessReasoningConfidence.none => 0.0,
        BusinessReasoningConfidence.low => 0.35,
        BusinessReasoningConfidence.medium => 0.6,
        BusinessReasoningConfidence.high => 0.85,
        BusinessReasoningConfidence.certain => 1.0,
      };

  Map<String, Object?> toDeterministicMap() => {
        'confidence': name,
        'score': score,
      };
}
