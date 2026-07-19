import 'assistant_insight_kind.dart';

/// Resolved analytical intent before planning an [AssistantInsightRequest].
sealed class AssistantInsightIntent {
  const AssistantInsightIntent();

  AssistantInsightKind get kind;
}

final class CountInsightIntent extends AssistantInsightIntent {
  const CountInsightIntent({this.statusToken});

  final String? statusToken;

  @override
  AssistantInsightKind get kind => AssistantInsightKind.count;
}

final class DistributionInsightIntent extends AssistantInsightIntent {
  const DistributionInsightIntent({this.groupBy = 'status'});

  final String groupBy;

  @override
  AssistantInsightKind get kind => AssistantInsightKind.distribution;
}

final class TopEntityInsightIntent extends AssistantInsightIntent {
  const TopEntityInsightIntent({this.entityField = 'clientDisplayName'});

  final String entityField;

  @override
  AssistantInsightKind get kind => AssistantInsightKind.topEntity;
}

final class LastCreatedInsightIntent extends AssistantInsightIntent {
  const LastCreatedInsightIntent();

  @override
  AssistantInsightKind get kind => AssistantInsightKind.lastCreated;
}

final class CreatedThisMonthInsightIntent extends AssistantInsightIntent {
  const CreatedThisMonthInsightIntent();

  @override
  AssistantInsightKind get kind => AssistantInsightKind.createdThisMonth;
}
