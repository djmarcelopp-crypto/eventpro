import '../domain/transaction_execution/assistant_transaction_execution_formatter.dart';
import '../domain/transaction_execution/assistant_transaction_execution_outcome.dart';
import '../domain/transaction_execution/assistant_transaction_execution_result.dart';
import '../models/assistant_transaction_execution_presentation.dart';

/// Deterministic NL + structured formatter for transaction execution.
class LocalAssistantTransactionExecutionFormatter
    implements AssistantTransactionExecutionFormatter {
  const LocalAssistantTransactionExecutionFormatter();

  @override
  AssistantTransactionExecutionPresentation format(
    AssistantTransactionExecutionResult result,
  ) {
    final nl = switch (result.outcome) {
      AssistantTransactionExecutionOutcome.completed =>
        result.summary ?? 'Execução concluída com sucesso.',
      AssistantTransactionExecutionOutcome.invalidConfirmation =>
        result.summary ?? 'Confirmação inválida — execução recusada.',
      AssistantTransactionExecutionOutcome.confirmationConsumed =>
        result.summary ?? 'Confirmação já consumida — token de uso único.',
      AssistantTransactionExecutionOutcome.confirmationCancelled =>
        result.summary ?? 'Confirmação cancelada — execução recusada.',
      AssistantTransactionExecutionOutcome.confirmationExpired =>
        result.summary ?? 'Confirmação expirada — execução recusada.',
      AssistantTransactionExecutionOutcome.planDivergence =>
        result.summary ?? 'Plano divergente da confirmação aprovada.',
      AssistantTransactionExecutionOutcome.invalidSession =>
        result.summary ?? 'Sessão inválida para execução.',
      AssistantTransactionExecutionOutcome.unsupportedOperation =>
        result.summary ?? 'Operação de escrita não suportada.',
      AssistantTransactionExecutionOutcome.writeFailed =>
        result.summary ?? 'Falha na escrita do orçamento draft.',
    };

    return AssistantTransactionExecutionPresentation.fromResult(
      result,
      naturalLanguage: nl,
    );
  }
}
