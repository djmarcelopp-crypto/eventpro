import 'assistant_confirmation_token.dart';

/// Resolved transaction-execution intent (distinct from AI-004/AI-013).
sealed class AssistantTransactionExecutionIntent {
  const AssistantTransactionExecutionIntent();
}

/// Execute a previously confirmed pending confirmation (Create Quote Draft).
final class ExecuteConfirmedTransactionIntent
    extends AssistantTransactionExecutionIntent {
  const ExecuteConfirmedTransactionIntent({this.token});

  final AssistantConfirmationToken? token;
}
