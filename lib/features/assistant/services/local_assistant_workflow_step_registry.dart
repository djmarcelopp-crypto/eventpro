import '../domain/workflow/assistant_workflow_step_handler.dart';
import '../domain/workflow/assistant_workflow_step_kind.dart';
import '../domain/workflow/assistant_workflow_step_registry.dart';

/// Map-backed registry — register handlers without a giant switch.
class LocalAssistantWorkflowStepRegistry
    implements AssistantWorkflowStepRegistry {
  LocalAssistantWorkflowStepRegistry([
    Map<AssistantWorkflowStepKind, AssistantWorkflowStepHandler>? handlers,
  ]) : _handlers = Map.unmodifiable(handlers ?? const {});

  final Map<AssistantWorkflowStepKind, AssistantWorkflowStepHandler> _handlers;

  /// Returns a new registry with [handler] registered for [kind].
  LocalAssistantWorkflowStepRegistry register(
    AssistantWorkflowStepKind kind,
    AssistantWorkflowStepHandler handler,
  ) {
    return LocalAssistantWorkflowStepRegistry({
      ..._handlers,
      kind: handler,
    });
  }

  Iterable<AssistantWorkflowStepKind> get registeredKinds => _handlers.keys;

  @override
  AssistantWorkflowStepHandler? handlerFor(AssistantWorkflowStepKind kind) =>
      _handlers[kind];
}
