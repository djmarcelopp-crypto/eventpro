import '../models/assistant_request.dart';
import '../models/assistant_response.dart';

/// Coordinates parse → intent → plan → controlled execution → optional write.
abstract class AssistantOrchestrator {
  Future<AssistantResponse> handle(AssistantRequest request);
}
