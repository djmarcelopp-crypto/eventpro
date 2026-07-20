import 'assistant_confirmation_result.dart';

/// Natural-language + structured presentation of a confirmation turn.
class AssistantConfirmationPresentation {
  const AssistantConfirmationPresentation({
    required this.naturalLanguage,
    required this.structured,
    this.warnings = const [],
  });

  final String naturalLanguage;
  final Map<String, Object?> structured;
  final List<String> warnings;

  factory AssistantConfirmationPresentation.fromResult(
    AssistantConfirmationResult result, {
    required String naturalLanguage,
  }) {
    return AssistantConfirmationPresentation(
      naturalLanguage: naturalLanguage,
      structured: result.toDeterministicMap(),
      warnings: result.warnings.map((w) => w.message).toList(growable: false),
    );
  }
}
