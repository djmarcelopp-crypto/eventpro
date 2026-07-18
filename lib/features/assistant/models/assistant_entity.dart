import 'assistant_confidence.dart';
import 'assistant_entity_type.dart';
import 'assistant_provenance.dart';

/// A single extracted or inferred piece of information from the source text.
class AssistantEntity {
  const AssistantEntity({
    required this.type,
    required this.rawValue,
    required this.provenance,
    this.normalizedValue,
    this.confidence = AssistantConfidence.none,
    this.sourceSpan,
  });

  final AssistantEntityType type;

  /// Surface form as found (or paraphrased) in the text.
  final String rawValue;

  /// Optional normalized representation (ISO date, HH:mm, int as string…).
  final String? normalizedValue;

  final AssistantProvenance provenance;
  final AssistantConfidence confidence;

  /// Optional substring of the original text that justified this entity.
  final String? sourceSpan;

  AssistantEntity copyWith({
    AssistantEntityType? type,
    String? rawValue,
    String? normalizedValue,
    AssistantProvenance? provenance,
    AssistantConfidence? confidence,
    String? sourceSpan,
    bool clearNormalizedValue = false,
    bool clearSourceSpan = false,
  }) {
    return AssistantEntity(
      type: type ?? this.type,
      rawValue: rawValue ?? this.rawValue,
      normalizedValue: clearNormalizedValue
          ? null
          : (normalizedValue ?? this.normalizedValue),
      provenance: provenance ?? this.provenance,
      confidence: confidence ?? this.confidence,
      sourceSpan: clearSourceSpan ? null : (sourceSpan ?? this.sourceSpan),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantEntity &&
            other.type == type &&
            other.rawValue == rawValue &&
            other.normalizedValue == normalizedValue &&
            other.provenance == provenance &&
            other.confidence == confidence &&
            other.sourceSpan == sourceSpan;
  }

  @override
  int get hashCode => Object.hash(
        type,
        rawValue,
        normalizedValue,
        provenance,
        confidence,
        sourceSpan,
      );
}
