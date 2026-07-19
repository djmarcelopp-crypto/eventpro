import '../models/assistant_conversation_context.dart';
import '../models/assistant_read_status_lexicon.dart';
import '../models/assistant_reference_kind.dart';

/// Resolved reference payload (kind + optional ordinal / status token).
class AssistantResolvedReference {
  const AssistantResolvedReference({
    required this.kind,
    this.ordinal,
    this.statusToken,
  });

  final AssistantReferenceKind kind;
  final int? ordinal;
  final String? statusToken;
}

/// Deterministic reference detection — context-only, no probabilistic NLP.
class LocalAssistantReferenceResolver {
  const LocalAssistantReferenceResolver();

  AssistantResolvedReference resolve(
    String rawText, {
    required AssistantConversationContext context,
  }) {
    final folded = AssistantReadStatusLexicon.fold(rawText)
        .replaceAll(RegExp(r'[?!.]+$'), '')
        .trim();

    if (_isClient(folded)) {
      return const AssistantResolvedReference(
        kind: AssistantReferenceKind.client,
      );
    }
    if (_isDetails(folded)) {
      return const AssistantResolvedReference(
        kind: AssistantReferenceKind.details,
      );
    }

    final ordinal = _extractOrdinal(folded);
    if (ordinal != null) {
      return AssistantResolvedReference(
        kind: AssistantReferenceKind.ordinal,
        ordinal: ordinal,
      );
    }

    if (_isNextPage(folded)) {
      return const AssistantResolvedReference(
        kind: AssistantReferenceKind.nextPage,
      );
    }
    if (_isNext(folded)) {
      return const AssistantResolvedReference(
        kind: AssistantReferenceKind.next,
      );
    }
    if (_isPrevious(folded)) {
      return const AssistantResolvedReference(
        kind: AssistantReferenceKind.previous,
      );
    }
    if (_isLast(folded)) {
      return const AssistantResolvedReference(
        kind: AssistantReferenceKind.last,
      );
    }
    if (_isThisOne(folded)) {
      return const AssistantResolvedReference(
        kind: AssistantReferenceKind.thisOne,
      );
    }

    final status = _extractStatusRefine(folded);
    if (status != null) {
      return AssistantResolvedReference(
        kind: AssistantReferenceKind.filterRefine,
        statusToken: status,
      );
    }

    return const AssistantResolvedReference(kind: AssistantReferenceKind.none);
  }

  static bool _isClient(String folded) =>
      folded.contains('quem e o cliente') ||
      folded.contains('qual o cliente') ||
      folded.contains('qual e o cliente') ||
      folded == 'cliente' ||
      folded.startsWith('cliente?') ||
      (folded.contains('cliente') &&
          (folded.contains('quem') || folded.contains('qual')));

  static bool _isDetails(String folded) =>
      folded.contains('detalhe') ||
      folded.contains('detalhes') ||
      folded.contains('mais informacoes') ||
      folded.contains('mostre os detalhes');

  static bool _isThisOne(String folded) =>
      folded == 'esse' ||
      folded == 'ele' ||
      folded == 'aquele' ||
      folded.contains('esse orcamento') ||
      folded.contains('este orcamento') ||
      folded.contains('aquele orcamento') ||
      (RegExp(r'\b(esse|ele|aquele)\b').hasMatch(folded) &&
          !RegExp(r'\bultimos?\b').hasMatch(folded) &&
          !folded.contains('anterior'));

  static bool _isLast(String folded) =>
      RegExp(r'\bo ultimo\b').hasMatch(folded) ||
      folded == 'ultimo' ||
      (folded.contains('mais recente') &&
          !folded.contains('ultimos orcamento'));

  static bool _isPrevious(String folded) =>
      folded.contains('anterior') || folded.contains('o anterior');

  static bool _isNext(String folded) =>
      folded == 'proximo' ||
      folded.contains('o proximo') ||
      (folded.contains('proximo') && !folded.contains('proximos'));

  static bool _isNextPage(String folded) =>
      folded.contains('proximos') ||
      folded == 'mais' ||
      folded.contains('mostrar mais') ||
      folded.contains('os proximos');

  static int? _extractOrdinal(String folded) {
    const words = {
      'primeiro': 1,
      'segunda': 2,
      'segundo': 2,
      'terceiro': 3,
      'terceira': 3,
      'quarto': 4,
      'quinta': 5,
      'quinto': 5,
    };
    for (final entry in words.entries) {
      if (folded.contains(entry.key)) return entry.value;
    }
    final match = RegExp(r'\bo\s+(\d{1,2})[oº°]?\b').firstMatch(folded);
    if (match != null) return int.tryParse(match.group(1)!);
    final eMatch = RegExp(r'\be\s+o\s+(\d{1,2})\b').firstMatch(folded);
    if (eMatch != null) return int.tryParse(eMatch.group(1)!);
    return null;
  }

  static String? _extractStatusRefine(String folded) {
    final refineCue = folded.contains('apenas') ||
        folded.contains('so os') ||
        folded.contains('somente') ||
        folded.contains('agora') ||
        folded.contains('filtre') ||
        folded.contains('filtrar');
    // Require an explicit refine cue so fresh AI-009 intents
    // (e.g. "Quantos orçamentos estão em aberto?") are not hijacked.
    if (!refineCue) return null;

    for (final token in [
      ...AssistantReadStatusLexicon.multiStatus.keys,
      ...AssistantReadStatusLexicon.singleStatus.keys,
    ]) {
      if (folded.contains(token)) return token;
    }
    return null;
  }
}
