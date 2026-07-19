import 'assistant_read_intent.dart';
import 'assistant_read_query.dart';
import 'assistant_reference_kind.dart';

/// Outcome of planning a conversational turn (follow-up or fresh).
class AssistantConversationPlan {
  const AssistantConversationPlan({
    required this.kind,
    this.intent,
    this.query,
    this.missingContext = false,
    this.missingContextMessage,
    this.contextualAnswer,
    this.focusIndex,
    this.isFollowUp = false,
  });

  final AssistantReferenceKind kind;
  final AssistantReadIntent? intent;
  final AssistantReadQuery? query;
  final bool missingContext;
  final String? missingContextMessage;

  /// Answer derived only from context (no ERP round-trip).
  final String? contextualAnswer;
  final int? focusIndex;
  final bool isFollowUp;

  bool get shouldExecuteRead =>
      !missingContext && contextualAnswer == null && intent != null;

  factory AssistantConversationPlan.fresh(AssistantReadIntent intent) {
    return AssistantConversationPlan(
      kind: AssistantReferenceKind.none,
      intent: intent,
      isFollowUp: false,
    );
  }

  factory AssistantConversationPlan.missingContext(String message) {
    return AssistantConversationPlan(
      kind: AssistantReferenceKind.none,
      missingContext: true,
      missingContextMessage: message,
      isFollowUp: true,
    );
  }

  factory AssistantConversationPlan.answer(String message) {
    return AssistantConversationPlan(
      kind: AssistantReferenceKind.client,
      contextualAnswer: message,
      isFollowUp: true,
    );
  }
}
