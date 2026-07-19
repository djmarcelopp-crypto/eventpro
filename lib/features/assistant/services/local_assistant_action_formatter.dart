import '../domain/action/assistant_action_formatter.dart';
import '../models/assistant_action_presentation.dart';
import '../models/assistant_action_result.dart';

/// Deterministic NL + structured formatter for smart actions.
class LocalAssistantActionFormatter implements AssistantActionFormatter {
  const LocalAssistantActionFormatter();

  @override
  AssistantActionPresentation format(AssistantActionResult result) {
    final parts = <String>[];
    if (result.summary != null && result.summary!.trim().isNotEmpty) {
      parts.add(result.summary!.trim());
    } else if (!result.valid) {
      parts.add(
        result.failureMessage ?? 'Não foi possível executar a ação.',
      );
    } else if (result.actions.isNotEmpty) {
      parts.add(
        result.actions.first.description ??
            result.actions.first.title ??
            'Ação executada.',
      );
    } else {
      parts.add('Nenhuma ação executada.');
    }

    for (final warning in result.warnings) {
      parts.add(warning.message);
    }

    return AssistantActionPresentation.fromResult(
      result,
      naturalLanguage: parts.join('\n\n'),
    );
  }
}
