import '../models/assistant_read_intent.dart';
import '../models/assistant_read_status_lexicon.dart';
import '../models/assistant_request.dart';
import 'assistant_capabilities.dart';

/// Deterministic text → [AssistantReadIntent] (no LLM / no ERP).
class LocalAssistantReadIntentResolver {
  const LocalAssistantReadIntentResolver();

  AssistantReadIntent? resolve({
    required AssistantRequest request,
    required AssistantCapabilities capabilities,
  }) {
    if (!capabilities.canPlanStructuredQuoteRead &&
        !capabilities.canExecuteStructuredQuoteRead) {
      return null;
    }

    final raw = request.rawText.trim();
    final folded = AssistantReadStatusLexicon.fold(raw);
    final mentionsQuote = _mentionsQuote(folded);
    if (!mentionsQuote && !_isBareRecentList(folded)) return null;
    if (!_looksLikeQuoteRead(folded, raw) && !_isBareRecentList(folded)) {
      return null;
    }

    final number = _extractQuoteNumber(raw) ?? _extractLooseNumber(folded);
    if (number != null &&
        (folded.contains('numero') ||
            folded.contains('existe') ||
            RegExp(r'orc-\d{4}-\d{4}').hasMatch(folded) ||
            folded.contains(number.toLowerCase()))) {
      return ReadQuoteByNumberIntent(number);
    }

    final id = _extractId(folded);
    if (id != null) {
      return ReadQuoteByIdIntent(id);
    }

    final customer = _extractCustomer(folded);
    if (customer != null) {
      return ReadQuoteByCustomerIntent(customer);
    }

    if (_isSummary(folded)) {
      return ReadQuoteSummaryIntent(statusToken: _extractStatusToken(folded));
    }

    final limit = _extractLimit(folded);
    if (_isRecent(folded)) {
      return ReadRecentQuotesIntent(limit: limit ?? 5);
    }

    final status = _extractStatusToken(folded);
    if (status != null || _isList(folded)) {
      return ReadQuotesIntent(statusToken: status, limit: limit);
    }

    if (_looksLikeQuoteRead(folded, raw)) {
      return ReadRecentQuotesIntent(limit: limit ?? 10);
    }
    return null;
  }

  static bool _mentionsQuote(String folded) =>
      folded.contains('orcamento') || folded.contains('quote');

  static bool _looksLikeQuoteRead(String folded, String raw) {
    const verbs = [
      'consultar',
      'listar',
      'buscar',
      'ultimos',
      'ultimo',
      'mostrar',
      'encontrar',
      'ver orcamento',
      'quantos',
      'existe',
      'mais recente',
    ];
    if (verbs.any(folded.contains)) return true;
    if (RegExp(r'ORC-\d{4}-\d{4}', caseSensitive: false).hasMatch(raw)) {
      return true;
    }
    if (folded.contains('status') && _mentionsQuote(folded)) return true;
    if (folded.contains('aberto') && _mentionsQuote(folded)) return true;
    return false;
  }

  static bool _isSummary(String folded) =>
      folded.contains('quantos') ||
      folded.contains('quantidade') ||
      folded.contains('resumo');

  static bool _isRecent(String folded) =>
      folded.contains('ultimos') ||
      folded.contains('ultimo') ||
      folded.contains('mais recente') ||
      folded.contains('recentes');

  static bool _isList(String folded) =>
      folded.contains('listar') ||
      folded.contains('liste') ||
      folded.contains('mostrar') ||
      folded.contains('mostre') ||
      folded.contains('consultar') ||
      folded.contains('buscar');

  /// "Liste os cinco últimos" without repeating "orçamentos".
  static bool _isBareRecentList(String folded) {
    if (!_isRecent(folded)) return false;
    return _isList(folded) ||
        folded.contains('cinco') ||
        RegExp(r'\b\d{1,2}\s+ultimos\b').hasMatch(folded);
  }

  static String? _extractQuoteNumber(String raw) {
    final match =
        RegExp(r'ORC-\d{4}-\d{4}', caseSensitive: false).firstMatch(raw);
    return match?.group(0)?.toUpperCase();
  }

  static String? _extractLooseNumber(String folded) {
    final match = RegExp(
      r'(?:numero|n[uº°]?)\s*(\d{3,})',
    ).firstMatch(folded);
    if (match != null) return match.group(1);
    final bare = RegExp(r'\b(\d{3,})\b').firstMatch(folded);
    if (bare != null &&
        (folded.contains('numero') || folded.contains('existe'))) {
      return bare.group(1);
    }
    return null;
  }

  static String? _extractId(String folded) {
    final match = RegExp(r'\bid[:=\s]+([a-z0-9\-_]{3,})\b').firstMatch(folded);
    return match?.group(1);
  }

  static String? _extractCustomer(String folded) {
    final cleaned = folded.replaceAll(RegExp(r'[?!.]+$'), '').trim();
    final match = RegExp(
      r'(?:para|do cliente|cliente)\s+([a-z][a-z\s]{1,40})$',
    ).firstMatch(cleaned);
    final name = match?.group(1)?.trim();
    if (name == null || name.isEmpty) return null;
    if (name == 'o' || name == 'a' || name.startsWith('orcamento')) {
      return null;
    }
    return name;
  }

  static String? _extractStatusToken(String folded) {
    for (final token in [
      ...AssistantReadStatusLexicon.multiStatus.keys,
      ...AssistantReadStatusLexicon.singleStatus.keys,
    ]) {
      if (folded.contains(token)) return token;
    }
    return null;
  }

  static int? _extractLimit(String folded) {
    const words = {
      'cinco': 5,
      'cinco ': 5,
      'tres': 3,
      'três': 3,
      'dez': 10,
      'dois': 2,
      'duas': 2,
    };
    for (final entry in words.entries) {
      if (folded.contains(entry.key.trim())) return entry.value;
    }
    final match = RegExp(r'\b(\d{1,2})\s+(ultimos|orcamentos)\b')
        .firstMatch(folded);
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }
}
