import '../models/assistant_request.dart';
import '../models/assistant_response.dart';

/// Coordinates parse → intent → drafts → response without ERP side effects.
abstract class AssistantOrchestrator {
  AssistantResponse handle(AssistantRequest request);
}
