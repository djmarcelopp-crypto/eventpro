import '../domain/confirmation/assistant_confirmation_formatter.dart';
import '../models/assistant_confirmation_outcome.dart';
import '../models/assistant_confirmation_presentation.dart';
import '../models/assistant_confirmation_result.dart';

/// Deterministic NL + structured formatter for safe confirmation results.
class LocalAssistantConfirmationFormatter
    implements AssistantConfirmationFormatter {
  const LocalAssistantConfirmationFormatter();

  @override
  AssistantConfirmationPresentation format(AssistantConfirmationResult result) {
    final parts = <String>[];

    switch (result.outcome) {
      case AssistantConfirmationOutcome.previewCreated:
        parts.add(result.summary ?? 'Confirmação criada.');
        if (result.preview != null) parts.add(result.preview!);
      case AssistantConfirmationOutcome.confirmed:
        parts.add(result.summary ?? 'Confirmação aceita.');
      case AssistantConfirmationOutcome.cancelled:
        parts.add(result.summary ?? 'Confirmação cancelada.');
      case AssistantConfirmationOutcome.expired:
        parts.add(result.summary ?? 'A confirmação expirou.');
      case AssistantConfirmationOutcome.missing:
        parts.add(result.summary ?? 'Não há confirmação pendente.');
      case AssistantConfirmationOutcome.invalid:
        parts.add(result.summary ?? 'Confirmação inválida.');
    }

    for (final warning in result.warnings) {
      if (!parts.contains(warning.message)) {
        parts.add(warning.message);
      }
    }

    return AssistantConfirmationPresentation.fromResult(
      result,
      naturalLanguage: parts.join('\n\n'),
    );
  }
}
