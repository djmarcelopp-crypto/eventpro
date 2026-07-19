import '../models/assistant_execution_plan.dart';
import '../models/assistant_execution_step.dart';
import '../models/assistant_intent_type.dart';
import '../models/assistant_response.dart';
import '../models/assistant_write_authorization.dart';
import '../models/assistant_write_capability.dart';
import '../models/assistant_write_constraint.dart';
import '../models/assistant_write_operation.dart';
import '../models/assistant_write_request.dart';
import '../models/assistant_write_target.dart';

/// Builds a write *intent* from the AI-004 pipeline — never executes.
class LocalAssistantWriteIntentFactory {
  const LocalAssistantWriteIntentFactory();

  /// Returns null when the primary intent has no corresponding write capability.
  AssistantWriteRequest? fromPipeline({
    required AssistantResponse response,
    required AssistantExecutionPlan plan,
  }) {
    final shape = _shapeForIntent(response.primaryIntent.type);
    if (shape == null) return null;

    final step = _findWriteStep(plan, shape.capability);
    final constraints = _constraintsFrom(step, response);
    final attributes = _attributesFrom(response);

    return AssistantWriteRequest(
      id: 'write-${response.requestId}-${shape.capability.name}',
      requestId: response.requestId,
      operation: shape.operation,
      target: shape.target,
      capability: shape.capability,
      constraints: constraints,
      attributes: attributes,
      relatedStepId: step?.id,
      authorization: AssistantWriteAuthorization(
        granted: true,
        requiresUserConfirmation: true,
        allowedCapabilities: {shape.capability},
        reason:
            'Intenção de escrita preparada para revisão — execução desabilitada',
      ),
    );
  }

  static ({
    AssistantWriteOperation operation,
    AssistantWriteTarget target,
    AssistantWriteCapability capability,
  })? _shapeForIntent(AssistantIntentType type) {
    switch (type) {
      case AssistantIntentType.createEvent:
        return (
          operation: AssistantWriteOperation.create,
          target: AssistantWriteTarget.event,
          capability: AssistantWriteCapability.createEvent,
        );
      case AssistantIntentType.createQuote:
        return (
          operation: AssistantWriteOperation.create,
          target: AssistantWriteTarget.quote,
          capability: AssistantWriteCapability.createQuote,
        );
      case AssistantIntentType.updateEvent:
        return (
          operation: AssistantWriteOperation.update,
          target: AssistantWriteTarget.event,
          capability: AssistantWriteCapability.updateEvent,
        );
      case AssistantIntentType.checkSchedule:
      case AssistantIntentType.checkAvailability:
      case AssistantIntentType.searchClient:
      case AssistantIntentType.unknown:
        return null;
    }
  }

  static AssistantExecutionStep? _findWriteStep(
    AssistantExecutionPlan plan,
    AssistantWriteCapability capability,
  ) {
    final action = capability.name;
    for (final step in plan.steps) {
      if (step.intendedAction == action) return step;
    }
    return null;
  }

  static List<AssistantWriteConstraint> _constraintsFrom(
    AssistantExecutionStep? step,
    AssistantResponse response,
  ) {
    final constraints = <AssistantWriteConstraint>[];
    if (step != null) {
      for (final requirement in step.preconditions) {
        constraints.add(
          AssistantWriteConstraint(
            id: requirement.id,
            description: requirement.description,
            satisfied: requirement.satisfied,
          ),
        );
      }
      if (step.blockReason != null && step.blockReason!.isNotEmpty) {
        constraints.add(
          AssistantWriteConstraint(
            id: 'block-${step.id}',
            description: step.blockReason!,
            satisfied: false,
          ),
        );
      }
    }
    if (response.questions.isNotEmpty) {
      constraints.add(
        const AssistantWriteConstraint(
          id: 'pending-questions',
          description: 'Perguntas pendentes no rascunho',
          satisfied: false,
        ),
      );
    }
    return List.unmodifiable(constraints);
  }

  static Map<String, String> _attributesFrom(AssistantResponse response) {
    final attributes = <String, String>{};
    final event = response.eventDraft;
    if (event != null) {
      if (event.eventType != null) attributes['eventType'] = event.eventType!;
      if (event.city != null) attributes['city'] = event.city!;
      if (event.guestCount != null) {
        attributes['guestCount'] = '${event.guestCount}';
      }
      if (event.date != null) {
        attributes['date'] = event.date!.toIso8601String();
      }
    }
    final quote = response.quoteDraft;
    if (quote != null && !quote.isEmpty) {
      final keywords = <String>{
        ...quote.serviceKeywords,
        ...quote.equipmentKeywords,
      };
      if (keywords.isNotEmpty) {
        attributes['keywords'] = keywords.take(8).join(',');
      }
    }
    return Map.unmodifiable(attributes);
  }
}
