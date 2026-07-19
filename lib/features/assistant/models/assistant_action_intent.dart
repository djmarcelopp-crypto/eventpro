import 'assistant_action_kind.dart';

/// Resolved navigation intent before planning an [AssistantActionRequest].
sealed class AssistantActionIntent {
  const AssistantActionIntent();

  AssistantActionKind get kind;
}

final class OpenQuotesActionIntent extends AssistantActionIntent {
  const OpenQuotesActionIntent();

  @override
  AssistantActionKind get kind => AssistantActionKind.openQuotes;
}

final class OpenClientActionIntent extends AssistantActionIntent {
  const OpenClientActionIntent({this.clientId, this.clientLabel});

  final String? clientId;
  final String? clientLabel;

  @override
  AssistantActionKind get kind => AssistantActionKind.openClient;
}

final class OpenLastQuoteActionIntent extends AssistantActionIntent {
  const OpenLastQuoteActionIntent({this.quoteId, this.quoteLabel});

  final String? quoteId;
  final String? quoteLabel;

  @override
  AssistantActionKind get kind => AssistantActionKind.openLastQuote;
}

final class OpenDashboardActionIntent extends AssistantActionIntent {
  const OpenDashboardActionIntent();

  @override
  AssistantActionKind get kind => AssistantActionKind.openDashboard;
}

final class OpenSettingsActionIntent extends AssistantActionIntent {
  const OpenSettingsActionIntent();

  @override
  AssistantActionKind get kind => AssistantActionKind.openSettings;
}
