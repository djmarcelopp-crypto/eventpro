import '../models/assistant_action_intent.dart';
import '../models/assistant_conversation_session.dart';
import '../models/assistant_read_status_lexicon.dart';
import '../models/assistant_request.dart';
import 'assistant_capabilities.dart';

/// Deterministic resolver for navigation smart-action intents.
class LocalAssistantActionIntentResolver {
  const LocalAssistantActionIntentResolver();

  AssistantActionIntent? resolve({
    required AssistantRequest request,
    required AssistantCapabilities capabilities,
    AssistantConversationSession? session,
  }) {
    if (!capabilities.canPlanSmartActions &&
        !capabilities.canExecuteSmartActions) {
      return null;
    }

    final folded = AssistantReadStatusLexicon.fold(request.rawText)
        .replaceAll(RegExp(r'[?!.]+$'), '')
        .trim();

    if (_isOpenSettings(folded)) {
      return const OpenSettingsActionIntent();
    }
    if (_isOpenDashboard(folded)) {
      return const OpenDashboardActionIntent();
    }
    if (_isOpenLastQuote(folded)) {
      final quoteId = request.context?.activeQuoteId ??
          session?.context.lastQuoteId;
      final quoteLabel = session?.context.lastQuoteNumber;
      return OpenLastQuoteActionIntent(
        quoteId: quoteId,
        quoteLabel: quoteLabel,
      );
    }
    if (_isOpenClient(folded)) {
      return OpenClientActionIntent(
        clientId: request.context?.activeClientId,
        clientLabel: session?.context.lastClientName,
      );
    }
    if (_isOpenQuotes(folded)) {
      return const OpenQuotesActionIntent();
    }

    return null;
  }

  static bool _isOpenSettings(String folded) =>
      folded.contains('abrir configuracoes') ||
      folded.contains('abra configuracoes') ||
      folded.contains('abrir settings') ||
      folded.contains('tela de configuracoes') ||
      folded.contains('ir para configuracoes') ||
      folded == 'configuracoes';

  static bool _isOpenDashboard(String folded) =>
      folded.contains('abrir dashboard') ||
      folded.contains('abra o dashboard') ||
      folded.contains('abra dashboard') ||
      folded.contains('abrir painel') ||
      folded.contains('ir para o inicio') ||
      folded.contains('ir para o dashboard') ||
      folded == 'dashboard';

  static bool _isOpenLastQuote(String folded) =>
      folded.contains('abra o ultimo orcamento') ||
      folded.contains('abrir o ultimo orcamento') ||
      folded.contains('abrir ultimo orcamento') ||
      folded.contains('abra ultimo orcamento') ||
      folded.contains('abrir o orcamento atual') ||
      (folded.contains('ultimo orcamento') &&
          (folded.contains('abra') || folded.contains('abrir')) &&
          !folded.contains('ultimos'));

  static bool _isOpenClient(String folded) =>
      folded.contains('abra o cliente') ||
      folded.contains('abrir o cliente') ||
      folded.contains('abrir cliente') ||
      folded.contains('abra cliente') ||
      folded.contains('tela do cliente') ||
      folded.contains('ir para o cliente');

  static bool _isOpenQuotes(String folded) =>
      folded.contains('abra orcamentos') ||
      folded.contains('abrir orcamentos') ||
      folded.contains('abra a tela de orcamentos') ||
      folded.contains('abrir a tela de orcamentos') ||
      folded.contains('tela de orcamentos') ||
      folded.contains('ir para orcamentos') ||
      folded.contains('ir para a tela de orcamentos') ||
      folded == 'orcamentos';
}
