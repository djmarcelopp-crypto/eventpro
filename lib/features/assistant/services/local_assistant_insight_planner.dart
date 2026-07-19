import '../domain/insight/assistant_insight_planner.dart';
import '../models/assistant_insight_intent.dart';
import '../models/assistant_insight_kind.dart';
import '../models/assistant_insight_request.dart';

/// Builds [AssistantInsightRequest] from intents — no DB, no Quotes types.
class LocalAssistantInsightPlanner implements AssistantInsightPlanner {
  const LocalAssistantInsightPlanner();

  @override
  AssistantInsightRequest plan(
    AssistantInsightIntent intent, {
    required String requestId,
    String? insightId,
    DateTime? referenceTimestamp,
  }) {
    final id = insightId ?? 'insight-$requestId';
    return switch (intent) {
      CountInsightIntent(:final statusToken) => AssistantInsightRequest(
          id: id,
          requestId: requestId,
          module: AssistantInsightModules.quote,
          kind: AssistantInsightKind.count,
          statusToken: statusToken,
          requiredCapabilities: const {
            AssistantInsightCapabilities.quoteInsights,
          },
        ),
      DistributionInsightIntent(:final groupBy) => AssistantInsightRequest(
          id: id,
          requestId: requestId,
          module: AssistantInsightModules.quote,
          kind: AssistantInsightKind.distribution,
          groupBy: groupBy,
          requiredCapabilities: const {
            AssistantInsightCapabilities.quoteInsights,
          },
        ),
      TopEntityInsightIntent(:final entityField) => AssistantInsightRequest(
          id: id,
          requestId: requestId,
          module: AssistantInsightModules.quote,
          kind: AssistantInsightKind.topEntity,
          groupBy: 'client',
          entityField: entityField,
          requiredCapabilities: const {
            AssistantInsightCapabilities.quoteInsights,
          },
        ),
      LastCreatedInsightIntent() => AssistantInsightRequest(
          id: id,
          requestId: requestId,
          module: AssistantInsightModules.quote,
          kind: AssistantInsightKind.lastCreated,
          requiredCapabilities: const {
            AssistantInsightCapabilities.quoteInsights,
          },
        ),
      CreatedThisMonthInsightIntent() => AssistantInsightRequest(
          id: id,
          requestId: requestId,
          module: AssistantInsightModules.quote,
          kind: AssistantInsightKind.createdThisMonth,
          referenceTimestamp: referenceTimestamp,
          requiredCapabilities: const {
            AssistantInsightCapabilities.quoteInsights,
          },
        ),
    };
  }
}
