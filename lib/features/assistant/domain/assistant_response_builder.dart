import '../models/assistant_entity.dart';
import '../models/assistant_event_draft.dart';
import '../models/assistant_intent.dart';
import '../models/assistant_parse_issue.dart';
import '../models/assistant_parse_result.dart';
import '../models/assistant_quote_draft.dart';
import '../models/assistant_request.dart';
import '../models/assistant_response.dart';

/// Assembles the final explainable [AssistantResponse].
abstract class AssistantResponseBuilder {
  AssistantResponse build({
    required AssistantRequest request,
    required AssistantParseResult parseResult,
    required AssistantIntent primaryIntent,
    required List<AssistantIntent> alternativeIntents,
    required AssistantEventDraft eventDraft,
    required AssistantQuoteDraft quoteDraft,
    required List<AssistantEntity> entities,
    required List<AssistantParseIssue> issues,
  });
}
