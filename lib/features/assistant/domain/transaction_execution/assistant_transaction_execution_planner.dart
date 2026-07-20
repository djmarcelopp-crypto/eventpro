import '../../models/assistant_confirmation_operation_kind.dart';
import '../../models/assistant_confirmation_session.dart';
import '../../models/assistant_confirmation_token.dart';
import '../../models/assistant_transaction_execution_intent.dart';
import 'assistant_transaction_execution_request.dart';
import 'assistant_transaction_execution_result.dart';

/// Validates a confirmed pending and builds an execution request.
///
/// Never performs ERP writes. Successful planning consumes the confirmation
/// token atomically so it cannot be reused.
abstract class AssistantTransactionExecutionPlanner {
  /// Returns a ready [AssistantTransactionExecutionRequest] when valid,
  /// otherwise a rejection [AssistantTransactionExecutionResult].
  ({
    AssistantTransactionExecutionRequest? request,
    AssistantTransactionExecutionResult? rejection,
  }) plan({
    required AssistantTransactionExecutionIntent intent,
    required String requestId,
    required String? sessionId,
    required AssistantConfirmationSession? session,
    required AssistantConfirmationOperationKind proposedOperationKind,
    required Map<String, String> proposedAttributes,
    AssistantConfirmationToken? token,
  });
}
