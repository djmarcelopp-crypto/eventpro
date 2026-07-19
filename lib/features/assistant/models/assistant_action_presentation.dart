import 'assistant_action_result.dart';

/// Natural-language + structured presentation of a smart action.
class AssistantActionPresentation {
  const AssistantActionPresentation({
    required this.naturalLanguage,
    required this.structured,
    this.warnings = const [],
  });

  final String naturalLanguage;
  final Map<String, Object?> structured;
  final List<String> warnings;

  factory AssistantActionPresentation.fromResult(
    AssistantActionResult result, {
    required String naturalLanguage,
  }) {
    return AssistantActionPresentation(
      naturalLanguage: naturalLanguage,
      structured: result.toDeterministicMap(),
      warnings: result.warnings.map((w) => w.message).toList(growable: false),
    );
  }
}
