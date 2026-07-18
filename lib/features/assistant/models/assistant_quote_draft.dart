import 'assistant_confidence.dart';

/// Structured quote hints — never creates a real [Quote].
class AssistantQuoteDraft {
  const AssistantQuoteDraft({
    this.equipmentKeywords = const [],
    this.serviceKeywords = const [],
    this.teamKeywords = const [],
    this.logisticsKeywords = const [],
    this.additionalNotes,
    this.confidence = AssistantConfidence.none,
  });

  final List<String> equipmentKeywords;
  final List<String> serviceKeywords;
  final List<String> teamKeywords;
  final List<String> logisticsKeywords;
  final String? additionalNotes;
  final AssistantConfidence confidence;

  bool get isEmpty =>
      equipmentKeywords.isEmpty &&
      serviceKeywords.isEmpty &&
      teamKeywords.isEmpty &&
      logisticsKeywords.isEmpty &&
      (additionalNotes == null || additionalNotes!.trim().isEmpty);

  AssistantQuoteDraft copyWith({
    List<String>? equipmentKeywords,
    List<String>? serviceKeywords,
    List<String>? teamKeywords,
    List<String>? logisticsKeywords,
    String? additionalNotes,
    AssistantConfidence? confidence,
    bool clearAdditionalNotes = false,
  }) {
    return AssistantQuoteDraft(
      equipmentKeywords: equipmentKeywords ?? this.equipmentKeywords,
      serviceKeywords: serviceKeywords ?? this.serviceKeywords,
      teamKeywords: teamKeywords ?? this.teamKeywords,
      logisticsKeywords: logisticsKeywords ?? this.logisticsKeywords,
      additionalNotes: clearAdditionalNotes
          ? null
          : (additionalNotes ?? this.additionalNotes),
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantQuoteDraft &&
            _listEquals(other.equipmentKeywords, equipmentKeywords) &&
            _listEquals(other.serviceKeywords, serviceKeywords) &&
            _listEquals(other.teamKeywords, teamKeywords) &&
            _listEquals(other.logisticsKeywords, logisticsKeywords) &&
            other.additionalNotes == additionalNotes &&
            other.confidence == confidence;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(equipmentKeywords),
        Object.hashAll(serviceKeywords),
        Object.hashAll(teamKeywords),
        Object.hashAll(logisticsKeywords),
        additionalNotes,
        confidence,
      );

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
