import '../../models/assistant_insight_request.dart';
import '../../models/assistant_insight_result.dart';

/// Module-specific insight executor (ERP adapters implement this).
abstract class AssistantInsightAdapter {
  String get name;
  String get module;

  bool supports(AssistantInsightRequest request);

  Future<AssistantInsightResult> execute(AssistantInsightRequest request);
}
