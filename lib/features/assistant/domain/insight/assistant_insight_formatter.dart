import '../../models/assistant_insight_presentation.dart';
import '../../models/assistant_insight_result.dart';

/// Formats insight results into NL + structured payload.
abstract class AssistantInsightFormatter {
  AssistantInsightPresentation format(AssistantInsightResult result);
}
