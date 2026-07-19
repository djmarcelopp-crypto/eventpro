import '../models/assistant_insight_intent.dart';
import '../models/assistant_read_status_lexicon.dart';
import '../models/assistant_request.dart';
import 'assistant_capabilities.dart';

/// Deterministic resolver for analytical quote insight intents.
class LocalAssistantInsightIntentResolver {
  const LocalAssistantInsightIntentResolver();

  AssistantInsightIntent? resolve({
    required AssistantRequest request,
    required AssistantCapabilities capabilities,
  }) {
    if (!capabilities.canPlanQuoteInsights &&
        !capabilities.canExecuteQuoteInsights) {
      return null;
    }

    final folded = AssistantReadStatusLexicon.fold(request.rawText)
        .replaceAll(RegExp(r'[?!.]+$'), '')
        .trim();

    if (_isDistribution(folded)) {
      return const DistributionInsightIntent(groupBy: 'status');
    }
    if (_isTopClient(folded)) {
      return const TopEntityInsightIntent(entityField: 'clientDisplayName');
    }
    if (_isCreatedThisMonth(folded)) {
      return const CreatedThisMonthInsightIntent();
    }
    if (_isLastCreated(folded)) {
      return const LastCreatedInsightIntent();
    }

    final countStatus = _extractCountStatus(folded);
    if (countStatus != null || _isTotalCount(folded)) {
      return CountInsightIntent(statusToken: countStatus);
    }

    return null;
  }

  static bool _isDistribution(String folded) =>
      folded.contains('concentracao') ||
      folded.contains('distribuicao') ||
      (folded.contains('por status') &&
          (folded.contains('concentra') ||
              folded.contains('distribu') ||
              folded.contains('existe') ||
              folded.contains('qual')));

  static bool _isTopClient(String folded) =>
      folded.contains('cliente possui mais') ||
      folded.contains('cliente com mais') ||
      folded.contains('qual cliente tem mais') ||
      (folded.contains('mais orcamentos') && folded.contains('cliente'));

  static bool _isCreatedThisMonth(String folded) =>
      folded.contains('este mes') ||
      folded.contains('neste mes') ||
      folded.contains('criados este mes') ||
      folded.contains('criados neste mes') ||
      (folded.contains('criados') && folded.contains('mes'));

  /// Singular analytical "último orçamento" — not "últimos orçamentos" lists.
  static bool _isLastCreated(String folded) =>
      folded.contains('qual foi o ultimo') ||
      folded.contains('qual o ultimo orcamento') ||
      RegExp(r'\bo ultimo orcamento\b').hasMatch(folded) ||
      (folded.contains('ultimo orcamento') &&
          !folded.contains('ultimos') &&
          !folded.contains('mostre') &&
          !folded.contains('liste'));

  static bool _isTotalCount(String folded) =>
      folded.contains('quantos orcamentos existem') ||
      folded.contains('quantos orcamentos ha') ||
      folded.contains('quantos orcamentos tem') ||
      folded == 'quantos orcamentos' ||
      folded.contains('total de orcamentos');

  static String? _extractCountStatus(String folded) {
    if (!folded.contains('quantos') && !folded.contains('quantidade')) {
      return null;
    }
    // Avoid stealing AI-009 summary phrasing when insights off — when on,
    // "quantos ... aberto/rascunho" is a COUNT insight.
    for (final token in [
      ...AssistantReadStatusLexicon.multiStatus.keys,
      ...AssistantReadStatusLexicon.singleStatus.keys,
    ]) {
      if (folded.contains(token)) return token;
    }
    return null;
  }
}
