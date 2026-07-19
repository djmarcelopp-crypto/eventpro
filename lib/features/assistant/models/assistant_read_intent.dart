/// Deterministic business intents for structured reads (AI-009).
///
/// Independent of the Quotes module — adapters interpret planned queries.
sealed class AssistantReadIntent {
  const AssistantReadIntent();

  String get kind;
}

/// Generic list of quotes, optionally constrained by a status token.
final class ReadQuotesIntent extends AssistantReadIntent {
  const ReadQuotesIntent({this.statusToken, this.limit});

  /// Lexical token (e.g. `aberto`, `rascunho`) — resolved by the planner.
  final String? statusToken;
  final int? limit;

  @override
  String get kind => 'readQuotes';
}

/// Lookup by opaque resource id.
final class ReadQuoteByIdIntent extends AssistantReadIntent {
  const ReadQuoteByIdIntent(this.quoteId);

  final String quoteId;

  @override
  String get kind => 'readQuoteById';
}

/// Lookup by quote number (full `ORC-…` or numeric fragment).
final class ReadQuoteByNumberIntent extends AssistantReadIntent {
  const ReadQuoteByNumberIntent(this.number);

  final String number;

  @override
  String get kind => 'readQuoteByNumber';
}

/// Recent quotes ordered by createdAt descending.
final class ReadRecentQuotesIntent extends AssistantReadIntent {
  const ReadRecentQuotesIntent({this.limit = 5});

  final int limit;

  @override
  String get kind => 'readRecentQuotes';
}

/// Aggregate / count-oriented read (e.g. "quantos estão em aberto").
final class ReadQuoteSummaryIntent extends AssistantReadIntent {
  const ReadQuoteSummaryIntent({this.statusToken});

  final String? statusToken;

  @override
  String get kind => 'readQuoteSummary';
}

/// Quotes matching a customer display name fragment.
final class ReadQuoteByCustomerIntent extends AssistantReadIntent {
  const ReadQuoteByCustomerIntent(this.customerName);

  final String customerName;

  @override
  String get kind => 'readQuoteByCustomer';
}
