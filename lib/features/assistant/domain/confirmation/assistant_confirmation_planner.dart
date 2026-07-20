import '../../models/assistant_confirmation_request.dart';
import '../../models/assistant_confirmation_result.dart';
import '../../models/assistant_confirmation_session.dart';
import '../../models/assistant_safe_confirmation_intent.dart';

/// Plans and validates safe confirmation lifecycle — never executes ERP actions.
abstract class AssistantConfirmationPlanner {
  AssistantConfirmationRequest planRequest(
    AssistantSafeConfirmationIntent intent, {
    required String requestId,
    String? sessionId,
  });

  AssistantConfirmationResult process({
    required AssistantConfirmationRequest request,
    required AssistantConfirmationSession? session,
  });
}
