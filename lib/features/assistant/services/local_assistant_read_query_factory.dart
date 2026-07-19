import '../domain/read/assistant_read_planner.dart';
import '../models/assistant_read_intent.dart';
import '../models/assistant_read_query.dart';
import '../models/assistant_request.dart';
import '../models/assistant_response.dart';
import 'assistant_capabilities.dart';
import 'local_assistant_read_intent_resolver.dart';
import 'local_assistant_read_planner.dart';

/// Thin AI-008-compatible wrapper: resolve intent → plan query.
///
/// All query assembly lives in [AssistantReadPlanner].
class LocalAssistantReadQueryFactory {
  const LocalAssistantReadQueryFactory({
    LocalAssistantReadIntentResolver? resolver,
    AssistantReadPlanner? planner,
  })  : _resolver = resolver ?? const LocalAssistantReadIntentResolver(),
        _planner = planner ?? const LocalAssistantReadPlanner();

  final LocalAssistantReadIntentResolver _resolver;
  final AssistantReadPlanner _planner;

  /// Resolves conversational intent (exposed for orchestrator/formatter).
  AssistantReadIntent? resolveIntent({
    required AssistantRequest request,
    required AssistantCapabilities capabilities,
  }) {
    return _resolver.resolve(
      request: request,
      capabilities: capabilities,
    );
  }

  AssistantReadQuery? fromPipeline({
    required AssistantRequest request,
    required AssistantResponse response,
    required AssistantCapabilities capabilities,
  }) {
    final intent = resolveIntent(
      request: request,
      capabilities: capabilities,
    );
    if (intent == null) return null;
    return _planner.plan(intent, requestId: request.id);
  }

  AssistantReadQuery planIntent(
    AssistantReadIntent intent, {
    required String requestId,
  }) {
    return _planner.plan(intent, requestId: requestId);
  }
}
