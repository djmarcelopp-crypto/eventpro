import '../domain/assistant_intent_classifier.dart';
import '../domain/assistant_orchestrator.dart';
import '../domain/assistant_parser.dart';
import '../domain/assistant_response_builder.dart';
import '../models/assistant_intent.dart';
import '../models/assistant_request.dart';
import '../models/assistant_response.dart';
import '../parsers/local_assistant_parser.dart';
import 'assistant_draft_builder.dart';
import 'local_assistant_intent_classifier.dart';
import 'local_assistant_response_builder.dart';

/// Local orchestration pipeline with no persistence and no ERP side effects.
class LocalAssistantOrchestrator implements AssistantOrchestrator {
  LocalAssistantOrchestrator({
    AssistantParser? parser,
    AssistantIntentClassifier? intentClassifier,
    AssistantResponseBuilder? responseBuilder,
    DateTime Function()? clock,
  })  : _parser = parser ?? LocalAssistantParser(clock: clock),
        _intentClassifier =
            intentClassifier ?? LocalAssistantIntentClassifier(),
        _responseBuilder =
            responseBuilder ?? LocalAssistantResponseBuilder();

  final AssistantParser _parser;
  final AssistantIntentClassifier _intentClassifier;
  final AssistantResponseBuilder _responseBuilder;

  @override
  AssistantResponse handle(AssistantRequest request) {
    final parseResult = _parser.parse(request);
    final intents = _intentClassifier.classify(
      request: request,
      parseResult: parseResult,
    );
    final primary = intents.first;
    final List<AssistantIntent> alternatives =
        intents.length > 1 ? intents.sublist(1) : const <AssistantIntent>[];

    final eventDraft = AssistantDraftBuilder.buildEventDraft(
      sourceText: request.rawText,
      entities: parseResult.entities,
    );
    final quoteDraft = AssistantDraftBuilder.buildQuoteDraft(
      entities: parseResult.entities,
    );

    return _responseBuilder.build(
      request: request,
      parseResult: parseResult,
      primaryIntent: primary,
      alternativeIntents: alternatives,
      eventDraft: eventDraft,
      quoteDraft: quoteDraft,
      entities: parseResult.entities,
      issues: parseResult.issues,
    );
  }
}
