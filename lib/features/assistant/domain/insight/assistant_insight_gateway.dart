import '../../models/assistant_insight_request.dart';
import '../../models/assistant_insight_result.dart';
import 'assistant_insight_adapter.dart';

/// Routes insight requests to the matching module adapter.
abstract class AssistantInsightGateway {
  bool get isAvailable;

  AssistantInsightAdapter? adapterFor(String module);

  Future<AssistantInsightResult> execute(AssistantInsightRequest request);
}
