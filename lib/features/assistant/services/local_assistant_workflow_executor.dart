import '../domain/workflow/assistant_workflow.dart';
import '../domain/workflow/assistant_workflow_context.dart';
import '../domain/workflow/assistant_workflow_execution_state.dart';
import '../domain/workflow/assistant_workflow_executor.dart';
import '../domain/workflow/assistant_workflow_metadata.dart';
import '../domain/workflow/assistant_workflow_result.dart';
import '../domain/workflow/assistant_workflow_step_registry.dart';
import '../domain/workflow/assistant_workflow_warning.dart';
import '../models/assistant_request.dart';

/// Sequential executor — delegates each step via the registry.
class LocalAssistantWorkflowExecutor implements AssistantWorkflowExecutor {
  LocalAssistantWorkflowExecutor({
    required AssistantWorkflowStepRegistry registry,
    DateTime Function()? clock,
  })  : _registry = registry,
        _clock = clock ?? DateTime.now;

  final AssistantWorkflowStepRegistry _registry;
  final DateTime Function() _clock;

  @override
  Future<AssistantWorkflowResult> execute({
    required AssistantWorkflow workflow,
    required AssistantRequest request,
    AssistantWorkflowContext initialContext = const AssistantWorkflowContext(),
  }) async {
    var state = AssistantWorkflowExecutionState(context: initialContext);

    if (workflow.steps.isEmpty) {
      return AssistantWorkflowResult(
        requestId: workflow.requestId,
        workflowId: workflow.id.value,
        context: state.context,
        stepOutcomes: const [],
        metadata: workflow.metadata,
        warnings: const [
          AssistantWorkflowWarning(
            code: AssistantWorkflowWarning.emptyWorkflow,
            message: 'Workflow sem etapas.',
          ),
        ],
        summary: 'Workflow vazio — nenhuma etapa executada.',
        valid: false,
      );
    }

    for (final step in workflow.steps) {
      final handler = _registry.handlerFor(step.kind);
      if (handler == null) {
        final warning = AssistantWorkflowWarning(
          code: AssistantWorkflowWarning.missingHandler,
          message: 'Handler ausente para ${step.kind.name}.',
        );
        final result = AssistantWorkflowStepResult(
          step: step,
          success: false,
          interrupt: step.required,
          message: warning.message,
          warnings: [warning],
        );
        state = state.appendResult(result).withWarning(warning);
        if (step.required) {
          state = state.markInterrupted();
          break;
        }
        continue;
      }

      final result = await handler.execute(
        step: step,
        context: state.context,
        request: request,
      );
      state = state.appendResult(result);

      if (!result.success && step.required) {
        state = state
            .withWarning(
              AssistantWorkflowWarning(
                code: AssistantWorkflowWarning.stepFailed,
                message: result.message ?? 'Etapa ${step.id} falhou.',
              ),
            )
            .markInterrupted();
        break;
      }
      if (result.interrupt) {
        state = state
            .withWarning(
              const AssistantWorkflowWarning(
                code: AssistantWorkflowWarning.interrupted,
                message: 'Workflow interrompido por uma etapa.',
              ),
            )
            .markInterrupted();
        break;
      }
    }

    final completedCount = state.completedStepCount;
    final completed =
        !state.interrupted && completedCount == workflow.steps.length;

    return AssistantWorkflowResult(
      requestId: workflow.requestId,
      workflowId: workflow.id.value,
      context: state.context,
      stepOutcomes: state.stepResults,
      metadata: AssistantWorkflowMetadata(
        workflowId: workflow.id.value,
        generatedAt: _clock().toUtc(),
        recipe: workflow.recipe,
        stepCount: workflow.steps.length,
        completedStepCount: completedCount,
        interrupted: state.interrupted,
      ),
      warnings: state.warnings,
      summary: state.interrupted
          ? 'Workflow interrompido após $completedCount etapa(s).'
          : 'Workflow concluído: $completedCount etapa(s).',
      valid: completed || (!state.interrupted && completedCount > 0),
      completed: completed,
      interrupted: state.interrupted,
    );
  }
}
