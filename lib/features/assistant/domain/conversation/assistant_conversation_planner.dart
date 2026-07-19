import '../../models/assistant_conversation_plan.dart';
import '../../models/assistant_conversation_session.dart';
import '../../models/assistant_request.dart';
import '../../services/assistant_capabilities.dart';

/// Plans a conversational turn using session context + deterministic rules.
abstract class AssistantConversationPlanner {
  AssistantConversationPlan plan({
    required AssistantRequest request,
    required AssistantConversationSession? session,
    required AssistantCapabilities capabilities,
  });
}
