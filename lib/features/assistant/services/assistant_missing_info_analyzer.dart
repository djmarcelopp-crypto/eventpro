import '../models/assistant_entity_type.dart';
import '../models/assistant_event_draft.dart';
import '../models/assistant_intent_type.dart';
import '../models/assistant_parse_issue.dart';
import '../models/assistant_parse_issue_type.dart';
import '../models/assistant_question.dart';
import '../models/assistant_quote_draft.dart';

/// Produces clarifying questions only for truly needed gaps.
abstract class AssistantMissingInfoAnalyzer {
  static List<AssistantQuestion> analyze({
    required AssistantIntentType intent,
    required AssistantEventDraft eventDraft,
    required AssistantQuoteDraft quoteDraft,
    required List<AssistantParseIssue> issues,
  }) {
    final questions = <AssistantQuestion>[];

    final needsEventShape = intent == AssistantIntentType.createEvent ||
        intent == AssistantIntentType.createQuote;

    if (!needsEventShape) return const [];

    if (eventDraft.date == null) {
      questions.add(
        const AssistantQuestion(
          id: 'ask-date',
          prompt: 'Qual é a data do evento?',
          relatedEntityType: AssistantEntityType.date,
        ),
      );
    }
    if (eventDraft.startTime == null || eventDraft.endTime == null) {
      questions.add(
        const AssistantQuestion(
          id: 'ask-time',
          prompt: 'Qual é o horário de início e término?',
          relatedEntityType: AssistantEntityType.startTime,
        ),
      );
    }
    if (eventDraft.city == null && eventDraft.venue == null) {
      questions.add(
        const AssistantQuestion(
          id: 'ask-place',
          prompt: 'Qual é o local ou endereço?',
          relatedEntityType: AssistantEntityType.venue,
        ),
      );
    }
    if (eventDraft.guestCount == null &&
        issues.any(
          (issue) =>
              issue.entityType == AssistantEntityType.guestCount &&
              (issue.type == AssistantParseIssueType.ambiguous ||
                  issue.type == AssistantParseIssueType.conflicting),
        )) {
      questions.add(
        const AssistantQuestion(
          id: 'ask-guests',
          prompt: 'Qual é a quantidade exata de convidados?',
          relatedEntityType: AssistantEntityType.guestCount,
        ),
      );
    }

    return List.unmodifiable(questions);
  }
}
