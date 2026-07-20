import 'assistant_confirmation_operation_kind.dart';
import 'assistant_confirmation_token.dart';

/// Resolved safe-confirmation intent (distinct from AI-004 step confirmation).
sealed class AssistantSafeConfirmationIntent {
  const AssistantSafeConfirmationIntent();
}

final class CreateConfirmationIntent extends AssistantSafeConfirmationIntent {
  const CreateConfirmationIntent({
    this.operationKind = AssistantConfirmationOperationKind.createQuoteDraft,
    this.approvedAttributes = const {},
  });

  final AssistantConfirmationOperationKind operationKind;

  /// Canonical attributes captured at confirmation create (AI-014 plan gate).
  final Map<String, String> approvedAttributes;
}

final class ConfirmPendingIntent extends AssistantSafeConfirmationIntent {
  const ConfirmPendingIntent({this.token});

  final AssistantConfirmationToken? token;
}

final class CancelPendingIntent extends AssistantSafeConfirmationIntent {
  const CancelPendingIntent({this.token});

  final AssistantConfirmationToken? token;
}

final class StatusPendingIntent extends AssistantSafeConfirmationIntent {
  const StatusPendingIntent();
}
