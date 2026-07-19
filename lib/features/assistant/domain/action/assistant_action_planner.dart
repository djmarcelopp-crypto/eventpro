import '../../models/assistant_action_intent.dart';
import '../../models/assistant_action_request.dart';
import '../../models/assistant_request.dart';

/// Translates action intent → request. Never navigates.
abstract class AssistantActionPlanner {
  AssistantActionRequest plan(
    AssistantActionIntent intent, {
    required AssistantRequest request,
    String? actionId,
  });
}
