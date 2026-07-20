import '../models/assistant_read_status_lexicon.dart';
import '../models/assistant_request.dart';
import '../models/assistant_workflow_intent.dart';
import 'assistant_capabilities.dart';

/// Deterministic resolver for multi-step workflow intents.
class LocalAssistantWorkflowIntentResolver {
  const LocalAssistantWorkflowIntentResolver();

  AssistantWorkflowIntent? resolve({
    required AssistantRequest request,
    required AssistantCapabilities capabilities,
  }) {
    if (!capabilities.canPlanWorkflow && !capabilities.canExecuteWorkflow) {
      return null;
    }

    final folded = AssistantReadStatusLexicon.fold(request.rawText)
        .replaceAll(RegExp(r'[?!.]+$'), '')
        .trim();

    if (_isConfirmationStatusThenAudit(folded)) {
      return const RunWorkflowIntent(
        AssistantWorkflowRecipe.confirmationStatusThenAudit,
      );
    }
    if (_isConfirmationCreateThenAudit(folded)) {
      return const RunWorkflowIntent(
        AssistantWorkflowRecipe.confirmationCreateThenAudit,
      );
    }
    if (_isReviewThenOpenLast(folded)) {
      return const RunWorkflowIntent(
        AssistantWorkflowRecipe.reviewQuotesThenOpenLast,
      );
    }

    // AI-017 business workflows — gated by business capability when present.
    if (capabilities.canPlanBusinessWorkflow ||
        capabilities.canExecuteBusinessWorkflow) {
      if (_isFindClientThenCreateQuote(folded)) {
        return const RunWorkflowIntent(
          AssistantWorkflowRecipe.findClientThenCreateQuote,
        );
      }
      if (_isFindEventThenOpenEvent(folded)) {
        return const RunWorkflowIntent(
          AssistantWorkflowRecipe.findEventThenOpenEvent,
        );
      }
      if (_isFindQuoteThenFindContract(folded)) {
        return const RunWorkflowIntent(
          AssistantWorkflowRecipe.findQuoteThenFindContract,
        );
      }
    }
    return null;
  }

  static bool _isConfirmationStatusThenAudit(String folded) =>
      (folded.contains('status da confirmacao') &&
          folded.contains('auditoria')) ||
      folded.contains('confirmacao pendente e historico de auditoria') ||
      folded.contains('status da confirmacao e historico de auditoria');

  static bool _isConfirmationCreateThenAudit(String folded) =>
      (folded.contains('solicitar confirmacao') &&
          folded.contains('auditoria')) ||
      folded.contains('criar confirmacao e consultar auditoria') ||
      folded.contains('solicitar confirmacao e mostrar auditoria');

  static bool _isReviewThenOpenLast(String folded) =>
      folded.contains('revisar orcamentos e abrir o ultimo') ||
      folded.contains('resumo de orcamentos e abrir o ultimo') ||
      folded.contains('mostrar ultimos orcamentos e abrir o ultimo');

  static bool _isFindClientThenCreateQuote(String folded) =>
      (folded.contains('buscar cliente') &&
          folded.contains('criar orcamento')) ||
      folded.contains('localizar cliente e criar orcamento') ||
      folded.contains('encontrar cliente e gerar orcamento');

  static bool _isFindEventThenOpenEvent(String folded) =>
      (folded.contains('buscar evento') && folded.contains('abrir')) ||
      folded.contains('localizar evento e abrir') ||
      folded.contains('encontrar evento e abrir');

  static bool _isFindQuoteThenFindContract(String folded) =>
      (folded.contains('buscar orcamento') &&
          folded.contains('contrato')) ||
      folded.contains('localizar orcamento e contrato') ||
      folded.contains('encontrar orcamento e contrato');
}
