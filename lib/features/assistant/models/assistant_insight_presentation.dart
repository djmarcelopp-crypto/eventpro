import 'assistant_insight_result.dart';

/// Natural-language + structured presentation of an insight result.
class AssistantInsightPresentation {
  const AssistantInsightPresentation({
    required this.naturalLanguage,
    required this.structured,
    this.warnings = const [],
  });

  final String naturalLanguage;
  final Map<String, Object?> structured;
  final List<String> warnings;

  factory AssistantInsightPresentation.fromResult(
    AssistantInsightResult result, {
    required String naturalLanguage,
  }) {
    return AssistantInsightPresentation(
      naturalLanguage: naturalLanguage,
      structured: result.toDeterministicMap(),
      warnings: result.warnings.map((w) => w.message).toList(growable: false),
    );
  }
}
