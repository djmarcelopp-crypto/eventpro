import '../domain/business/capabilities/assistant_business_capability.dart';
import '../domain/business/capabilities/assistant_business_capability_id.dart';
import '../domain/business/capabilities/assistant_business_capability_registry.dart';
import '../domain/business/capabilities/assistant_business_capability_resolution.dart';
import '../domain/business/capabilities/assistant_business_capability_resolver.dart';
import '../domain/business/capabilities/capability_execution_node.dart';
import '../domain/workflow/assistant_workflow.dart';
import '../domain/workflow/assistant_workflow_definition_registry.dart';
import '../domain/workflow/assistant_workflow_execution_plan.dart';
import '../domain/workflow/assistant_workflow_planner.dart';
import '../domain/workflow/assistant_workflow_step_kind.dart';
import '../models/assistant_request.dart';
import '../models/assistant_workflow_intent.dart';
import 'local_assistant_business_capability_registry.dart';
import 'local_assistant_business_capability_resolver.dart';
import 'local_assistant_workflow_definition_registry.dart';

/// Deterministic planner — definition → capability resolve → execution plan.
///
/// Does **not** know the Business Gateway. Concrete recipes live in the
/// definition registry; capabilities live in the capability registry.
class LocalAssistantWorkflowPlanner implements AssistantWorkflowPlanner {
  factory LocalAssistantWorkflowPlanner({
    DateTime Function()? clock,
    AssistantWorkflowDefinitionRegistry? definitionRegistry,
    AssistantBusinessCapabilityRegistry? capabilityRegistry,
    AssistantBusinessCapabilityResolver? capabilityResolver,
  }) {
    final capabilities = capabilityRegistry ??
        LocalAssistantBusinessCapabilityRegistry.defaults();
    return LocalAssistantWorkflowPlanner._(
      clock: clock ?? DateTime.now,
      definitions: definitionRegistry ??
          LocalAssistantWorkflowDefinitionRegistry.defaults(),
      capabilities: capabilities,
      capabilityResolver: capabilityResolver ??
          LocalAssistantBusinessCapabilityResolver(registry: capabilities),
    );
  }

  LocalAssistantWorkflowPlanner._({
    required DateTime Function() clock,
    required AssistantWorkflowDefinitionRegistry definitions,
    required AssistantBusinessCapabilityRegistry capabilities,
    required AssistantBusinessCapabilityResolver capabilityResolver,
  })  : _clock = clock,
        _definitions = definitions,
        _capabilities = capabilities,
        _capabilityResolver = capabilityResolver;

  final DateTime Function() _clock;
  final AssistantWorkflowDefinitionRegistry _definitions;
  final AssistantBusinessCapabilityRegistry _capabilities;
  final AssistantBusinessCapabilityResolver _capabilityResolver;

  AssistantWorkflowDefinitionRegistry get definitionRegistry => _definitions;

  AssistantBusinessCapabilityRegistry get capabilityRegistry => _capabilities;

  AssistantBusinessCapabilityResolver get capabilityResolver =>
      _capabilityResolver;

  @override
  AssistantWorkflow? plan(
    AssistantWorkflowIntent intent, {
    required String requestId,
    required AssistantRequest request,
  }) {
    final plan = planExecution(
      intent,
      requestId: requestId,
      request: request,
    );
    return plan?.toWorkflow();
  }

  /// Preferred API — returns the formal execution plan.
  AssistantWorkflowExecutionPlan? planExecution(
    AssistantWorkflowIntent intent, {
    required String requestId,
    required AssistantRequest request,
  }) {
    if (intent is! RunWorkflowIntent) return null;

    final definition = _definitions.find(intent.recipe.name);
    if (definition == null || definition.steps.isEmpty) return null;

    final capabilityIds = <AssistantBusinessCapabilityId>[];
    final inputsById = <String, Map<String, String>>{};
    final stepIdsByCapabilityId = <String, String>{};

    for (final step in definition.steps) {
      if (step.kind != AssistantWorkflowStepKind.business) continue;

      final operation = step.params['operation']?.trim();
      if (operation == null || operation.isEmpty) return null;

      final AssistantBusinessCapability? capability =
          _capabilities.findByOperationCode(operation);
      if (capability == null) return null;

      capabilityIds.add(capability.id);
      final inputs = Map<String, String>.from(step.params)..remove('operation');
      inputsById[capability.id.value] = inputs;
      stepIdsByCapabilityId[capability.id.value] = step.id;
    }

    final List<AssistantBusinessCapabilityResolution> resolutions =
        capabilityIds.isEmpty
            ? const []
            : _capabilityResolver.resolveSequence(
                ids: capabilityIds,
                inputsByCapabilityId: inputsById,
              );

    if (capabilityIds.isNotEmpty && resolutions.any((r) => !r.ready)) {
      return null;
    }

    final executionNodes = <CapabilityExecutionNode>[
      for (var i = 0; i < resolutions.length; i++)
        CapabilityExecutionNode(
          index: i,
          capabilityId: capabilityIds[i],
          version: resolutions[i].capability?.version,
          category: resolutions[i].capability?.category,
          status: resolutions[i].status,
          resolution: resolutions[i],
          operationCode: resolutions[i].capability?.operationCode,
          stepId: stepIdsByCapabilityId[capabilityIds[i].value],
        ),
    ];

    return AssistantWorkflowExecutionPlan.fromDefinition(
      definition: definition,
      requestId: requestId,
      generatedAt: _clock().toUtc(),
      resolvedCapabilities: resolutions,
      executionNodes: executionNodes,
    );
  }
}
