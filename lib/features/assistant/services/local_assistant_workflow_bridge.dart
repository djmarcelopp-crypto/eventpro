import '../domain/action/assistant_action_gateway.dart';
import '../domain/action/assistant_action_planner.dart';
import '../domain/audit/assistant_audit_query.dart';
import '../domain/audit/assistant_audit_query_service.dart';
import '../domain/confirmation/assistant_confirmation_planner.dart';
import '../domain/insight/assistant_insight_gateway.dart';
import '../domain/insight/assistant_insight_planner.dart';
import '../domain/workflow/assistant_workflow_context.dart';
import '../domain/workflow/assistant_workflow_result.dart';
import '../domain/workflow/assistant_workflow_step.dart';
import '../domain/workflow/assistant_workflow_step_kind.dart';
import '../domain/workflow/assistant_workflow_warning.dart';
import '../models/assistant_action_intent.dart';
import '../models/assistant_insight_intent.dart';
import '../models/assistant_safe_confirmation_intent.dart';
import 'assistant_confirmation_session_registry.dart';
import 'callback_assistant_workflow_step_handler.dart';
import 'local_assistant_action_planner.dart';
import 'local_assistant_insight_planner.dart';
import 'local_assistant_workflow_step_registry.dart';

/// Builds a step registry that delegates to existing pipelines (no duplication).
class LocalAssistantWorkflowBridge {
  const LocalAssistantWorkflowBridge();

  LocalAssistantWorkflowStepRegistry buildRegistry({
    required AssistantConfirmationPlanner confirmationPlanner,
    required AssistantConfirmationSessionRegistry confirmationSessions,
    required AssistantAuditQueryService auditQueryService,
    required AssistantActionGateway actionGateway,
    AssistantInsightGateway? insightGateway,
    AssistantInsightPlanner insightPlanner =
        const LocalAssistantInsightPlanner(),
    AssistantActionPlanner actionPlanner = const LocalAssistantActionPlanner(),
    DateTime Function()? clock,
  }) {
    final now = clock ?? DateTime.now;
    var registry = LocalAssistantWorkflowStepRegistry();

    registry = registry.register(
      AssistantWorkflowStepKind.confirmation,
      CallbackAssistantWorkflowStepHandler(({
        required step,
        required context,
        required request,
      }) async {
        final sessionId = request.context?.sessionId?.trim();
        final session = (sessionId != null && sessionId.isNotEmpty)
            ? confirmationSessions.getOrCreate(sessionId)
            : null;
        final intentKind = step.params['intentKind'] ?? 'status';
        final intent = switch (intentKind) {
          'create' => const CreateConfirmationIntent(),
          'confirm' => const ConfirmPendingIntent(),
          'cancel' => const CancelPendingIntent(),
          _ => const StatusPendingIntent(),
        };
        final confRequest = confirmationPlanner.planRequest(
          intent,
          requestId: request.id,
          sessionId: sessionId,
        );
        final result = confirmationPlanner.process(
          request: confRequest,
          session: session,
        );
        return AssistantWorkflowStepOutcome(
          step: step,
          success: result.valid,
          interrupt: !result.valid && step.required,
          message: result.summary,
          outputs: {
            'confirmationResult': result,
            'confirmationOutcome': result.outcome.name,
          },
        );
      }),
    );

    registry = registry.register(
      AssistantWorkflowStepKind.audit,
      CallbackAssistantWorkflowStepHandler(({
        required step,
        required context,
        required request,
      }) async {
        final sessionId = request.context?.sessionId?.trim();
        final result = auditQueryService.query(
          AssistantAuditQuery(
            requestId: request.id,
            sessionId: sessionId,
          ),
        );
        return AssistantWorkflowStepOutcome(
          step: step,
          success: result.valid,
          message: result.summary,
          outputs: {
            'auditResult': result,
            'auditEventCount': result.returnedCount,
          },
        );
      }),
    );

    registry = registry.register(
      AssistantWorkflowStepKind.insight,
      CallbackAssistantWorkflowStepHandler(({
        required step,
        required context,
        required request,
      }) async {
        if (insightGateway == null) {
          return AssistantWorkflowStepOutcome(
            step: step,
            success: false,
            interrupt: step.required,
            message: 'Insight gateway indisponível.',
            warnings: const [
              AssistantWorkflowWarning(
                code: AssistantWorkflowWarning.missingHandler,
                message: 'Insight gateway não configurado.',
              ),
            ],
          );
        }
        final insightIntent = const LastCreatedInsightIntent();
        final insightRequest = insightPlanner.plan(
          insightIntent,
          requestId: request.id,
          referenceTimestamp: now().toUtc(),
        );
        final result = await insightGateway.execute(insightRequest);
        return AssistantWorkflowStepOutcome(
          step: step,
          success: result.valid,
          interrupt: !result.valid && step.required,
          message: result.summary?.toString(),
          outputs: {
            'insightResult': result,
          },
        );
      }),
    );

    registry = registry.register(
      AssistantWorkflowStepKind.action,
      CallbackAssistantWorkflowStepHandler(({
        required step,
        required context,
        required request,
      }) async {
        final actionIntent = _actionIntentFromParams(step, context);
        final actionRequest = actionPlanner.plan(
          actionIntent,
          request: request,
        );
        final result = await actionGateway.execute(actionRequest);
        return AssistantWorkflowStepOutcome(
          step: step,
          success: result.valid,
          interrupt: !result.valid && step.required,
          message: result.summary,
          outputs: {
            'actionResult': result,
          },
        );
      }),
    );

    registry = registry.register(
      AssistantWorkflowStepKind.read,
      CallbackAssistantWorkflowStepHandler(({
        required step,
        required context,
        required request,
      }) async {
        return AssistantWorkflowStepOutcome(
          step: step,
          success: true,
          message: 'Read step reconhecido (sem execução nestas recipes).',
          outputs: const {'read': 'skipped'},
        );
      }),
    );

    registry = registry.register(
      AssistantWorkflowStepKind.transactionExecution,
      CallbackAssistantWorkflowStepHandler(({
        required step,
        required context,
        required request,
      }) async {
        return AssistantWorkflowStepOutcome(
          step: step,
          success: true,
          message:
              'Transaction execution step reconhecido (sem execução nestas recipes).',
          outputs: const {'transactionExecution': 'skipped'},
        );
      }),
    );

    return registry;
  }

  static AssistantActionIntent _actionIntentFromParams(
    AssistantWorkflowStep step,
    AssistantWorkflowContext context,
  ) {
    final kind = step.params['action'] ?? 'openLastQuote';
    if (kind == 'openQuotes') return const OpenQuotesActionIntent();
    return OpenLastQuoteActionIntent(
      quoteId: context['lastQuoteId'] as String?,
    );
  }
}
