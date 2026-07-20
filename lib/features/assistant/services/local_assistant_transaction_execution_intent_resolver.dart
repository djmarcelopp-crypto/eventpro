import '../models/assistant_read_status_lexicon.dart';
import '../models/assistant_request.dart';
import '../models/assistant_transaction_execution_intent.dart';
import 'assistant_capabilities.dart';

/// Deterministic resolver for transaction-execution intents.
class LocalAssistantTransactionExecutionIntentResolver {
  const LocalAssistantTransactionExecutionIntentResolver();

  AssistantTransactionExecutionIntent? resolve({
    required AssistantRequest request,
    required AssistantCapabilities capabilities,
  }) {
    if (!capabilities.canPlanTransactionExecution &&
        !capabilities.canExecuteTransactionExecution) {
      return null;
    }

    final folded = AssistantReadStatusLexicon.fold(request.rawText)
        .replaceAll(RegExp(r'[?!.]+$'), '')
        .trim();

    if (_isExecute(folded)) {
      return const ExecuteConfirmedTransactionIntent();
    }
    return null;
  }

  static bool _isExecute(String folded) =>
      folded == 'executar' ||
      folded == 'executar agora' ||
      folded.contains('executar operacao confirmada') ||
      folded.contains('executar a operacao confirmada') ||
      folded.contains('executar orcamento confirmado') ||
      folded.contains('executar confirmacao') ||
      folded.contains('realizar operacao confirmada') ||
      folded.contains('concluir operacao confirmada');
}
