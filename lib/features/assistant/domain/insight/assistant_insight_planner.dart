import '../../models/assistant_insight_intent.dart';
import '../../models/assistant_insight_request.dart';

/// Translates insight intent → request. No I/O, no ERP knowledge.
abstract class AssistantInsightPlanner {
  AssistantInsightRequest plan(
    AssistantInsightIntent intent, {
    required String requestId,
    String? insightId,
    DateTime? referenceTimestamp,
  });
}
