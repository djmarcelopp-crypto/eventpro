/// Centralized, explicit status token mapping for conversational reads.
///
/// Tokens are folded (accents stripped, lowercased) before lookup.
abstract final class AssistantReadStatusLexicon {
  /// Single-status tokens → canonical status name.
  static const Map<String, String> singleStatus = {
    'draft': 'draft',
    'rascunho': 'draft',
    'sent': 'sent',
    'enviado': 'sent',
    'approved': 'approved',
    'aprovado': 'approved',
    'rejected': 'rejected',
    'recusado': 'rejected',
    'cancelled': 'cancelled',
    'cancelado': 'cancelled',
  };

  /// Multi-status aliases (e.g. open quotes).
  static const Map<String, List<String>> multiStatus = {
    'aberto': ['draft', 'sent'],
    'abertos': ['draft', 'sent'],
    'open': ['draft', 'sent'],
  };

  /// Resolves a token to one status, or null if multi/unknown.
  static String? resolveSingle(String token) {
    final key = fold(token);
    return singleStatus[key];
  }

  /// Resolves a token to one or more statuses.
  static List<String>? resolveStatuses(String token) {
    final key = fold(token);
    final multi = multiStatus[key];
    if (multi != null) return List.unmodifiable(multi);
    final single = singleStatus[key];
    if (single != null) return [single];
    return null;
  }

  static String fold(String input) {
    return input
        .trim()
        .toLowerCase()
        .replaceAll('ç', 'c')
        .replaceAll('ã', 'a')
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u');
  }
}
