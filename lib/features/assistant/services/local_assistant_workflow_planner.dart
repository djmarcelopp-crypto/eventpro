import '../domain/business/capabilities/assistant_business_capability.dart';
import '../domain/business/capabilities/assistant_business_capability_constraint.dart';
import '../domain/business/capabilities/assistant_business_capability_id.dart';
import '../domain/business/capabilities/assistant_business_capability_registry.dart';
import '../domain/business/capabilities/assistant_business_capability_resolution.dart';
import '../domain/business/capabilities/assistant_business_capability_resolver.dart';
import '../domain/business/capabilities/capability_execution_node.dart';
import '../domain/business/commands/assistant_business_command.dart';
import '../domain/business/commands/assistant_business_command_id.dart';
import '../domain/business/commands/assistant_business_command_registry.dart';
import '../domain/business/commands/assistant_business_command_resolution.dart';
import '../domain/business/commands/assistant_business_command_resolver.dart';
import '../domain/business/commands/command_execution_node.dart';
import '../domain/workflow/assistant_workflow.dart';
import '../domain/workflow/assistant_workflow_definition_registry.dart';
import '../domain/workflow/assistant_workflow_execution_plan.dart';
import '../domain/workflow/assistant_workflow_planner.dart';
import '../domain/workflow/assistant_workflow_step_kind.dart';
import '../models/assistant_request.dart';
import '../models/assistant_workflow_intent.dart';
import 'local_assistant_business_capability_registry.dart';
import 'local_assistant_business_capability_resolver.dart';
import 'local_assistant_business_command_registry.dart';
import 'local_assistant_business_command_resolver.dart';
import 'local_assistant_workflow_definition_registry.dart';

/// Deterministic planner —
/// definition → Command(by operationCode) → CommandResolver(→Capability) → plan.
///
/// Does **not** know the Business Gateway.
class LocalAssistantWorkflowPlanner implements AssistantWorkflowPlanner {
  factory LocalAssistantWorkflowPlanner({
    DateTime Function()? clock,
    AssistantWorkflowDefinitionRegistry? definitionRegistry,
    AssistantBusinessCapabilityRegistry? capabilityRegistry,
    AssistantBusinessCapabilityResolver? capabilityResolver,
    AssistantBusinessCommandRegistry? commandRegistry,
    AssistantBusinessCommandResolver? commandResolver,
  }) {
    final capabilities = capabilityRegistry ??
        LocalAssistantBusinessCapabilityRegistry.defaults();
    final commands =
        commandRegistry ?? LocalAssistantBusinessCommandRegistry.defaults();
    return LocalAssistantWorkflowPlanner._(
      clock: clock ?? DateTime.now,
      definitions: definitionRegistry ??
          LocalAssistantWorkflowDefinitionRegistry.defaults(),
      capabilities: capabilities,
      capabilityResolver: capabilityResolver ??
          LocalAssistantBusinessCapabilityResolver(registry: capabilities),
      commands: commands,
      commandResolver: commandResolver ??
          LocalAssistantBusinessCommandResolver(
            registry: commands,
            capabilityRegistry: capabilities,
          ),
    );
  }

  LocalAssistantWorkflowPlanner._({
    required DateTime Function() clock,
    required AssistantWorkflowDefinitionRegistry definitions,
    required AssistantBusinessCapabilityRegistry capabilities,
    required AssistantBusinessCapabilityResolver capabilityResolver,
    required AssistantBusinessCommandRegistry commands,
    required AssistantBusinessCommandResolver commandResolver,
  })  : _clock = clock,
        _definitions = definitions,
        _capabilities = capabilities,
        _capabilityResolver = capabilityResolver,
        _commands = commands,
        _commandResolver = commandResolver;

  final DateTime Function() _clock;
  final AssistantWorkflowDefinitionRegistry _definitions;
  final AssistantBusinessCapabilityRegistry _capabilities;
  final AssistantBusinessCapabilityResolver _capabilityResolver;
  final AssistantBusinessCommandRegistry _commands;
  final AssistantBusinessCommandResolver _commandResolver;

  AssistantWorkflowDefinitionRegistry get definitionRegistry => _definitions;

  AssistantBusinessCapabilityRegistry get capabilityRegistry => _capabilities;

  AssistantBusinessCapabilityResolver get capabilityResolver =>
      _capabilityResolver;

  AssistantBusinessCommandRegistry get commandRegistry => _commands;

  AssistantBusinessCommandResolver get commandResolver => _commandResolver;

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

    final commandIds = <AssistantBusinessCommandId>[];
    final paramsByCommandId = <String, Map<String, String>>{};
    final stepIdsByCommandId = <String, String>{};
    final commandsInOrder = <AssistantBusinessCommand>[];

    for (final step in definition.steps) {
      if (step.kind != AssistantWorkflowStepKind.business) continue;

      final operation = step.params['operation']?.trim();
      if (operation == null || operation.isEmpty) return null;

      final AssistantBusinessCommand? command =
          _commands.findByOperationCode(operation);
      if (command == null) return null;

      commandIds.add(command.id);
      commandsInOrder.add(command);
      final params = Map<String, String>.from(step.params)..remove('operation');
      paramsByCommandId[command.id.value] = params;
      stepIdsByCommandId[command.id.value] = step.id;
    }

    final List<AssistantBusinessCommandResolution> commandResolutions =
        commandIds.isEmpty
            ? const []
            : _commandResolver.resolveSequence(
                ids: commandIds,
                parametersByCommandId: paramsByCommandId,
              );

    if (commandIds.isNotEmpty && commandResolutions.any((r) => !r.ready)) {
      return null;
    }

    final capabilityIds = <AssistantBusinessCapabilityId>[];
    final inputsByCapabilityId = <String, Map<String, String>>{};
    final stepIdsByCapabilityId = <String, String>{};
    final capabilitiesInOrder = <AssistantBusinessCapability>[];

    for (var i = 0; i < commandResolutions.length; i++) {
      final capability = commandResolutions[i].resolvedCapability;
      if (capability == null) return null;
      capabilityIds.add(capability.id);
      capabilitiesInOrder.add(capability);
      inputsByCapabilityId[capability.id.value] =
          paramsByCommandId[commandIds[i].value] ?? const {};
      stepIdsByCapabilityId[capability.id.value] =
          stepIdsByCommandId[commandIds[i].value]!;
    }

    final List<AssistantBusinessCapabilityResolution> capabilityResolutions =
        capabilityIds.isEmpty
            ? const []
            : _capabilityResolver.resolveSequence(
                ids: capabilityIds,
                inputsByCapabilityId: inputsByCapabilityId,
              );

    if (capabilityIds.isNotEmpty &&
        capabilityResolutions.any((r) => !r.ready)) {
      return null;
    }

    final outputProducerIndex = <String, int>{};
    final commandExecutionNodes = <CommandExecutionNode>[];

    for (var i = 0; i < commandResolutions.length; i++) {
      final command = commandsInOrder[i];
      final capability = capabilitiesInOrder[i];
      final deps = <int>{};

      for (final constraint in capability.constraints) {
        if (constraint.kind !=
            AssistantBusinessCapabilityConstraintKind
                .requiresSatisfiedDependency) {
          continue;
        }
        final producer = outputProducerIndex[constraint.key];
        if (producer != null) deps.add(producer);
      }

      final produced =
          command.results.map((r) => r.key).toList(growable: false);
      for (final key in produced) {
        outputProducerIndex[key] = i;
      }

      final depList = deps.toList()..sort();
      commandExecutionNodes.add(
        CommandExecutionNode(
          plannerOrder: i,
          commandId: commandIds[i],
          version: command.version,
          category: command.category,
          status: commandResolutions[i].resolutionStatus,
          resolution: commandResolutions[i],
          operationCode: command.operationCode,
          stepId: stepIdsByCommandId[commandIds[i].value],
          dependencyIndexes: List.unmodifiable(depList),
          producedOutputs: List.unmodifiable(produced),
        ),
      );
    }

    final executionNodes = <CapabilityExecutionNode>[
      for (var i = 0; i < capabilityResolutions.length; i++)
        CapabilityExecutionNode(
          index: i,
          capabilityId: capabilityIds[i],
          version: capabilityResolutions[i].capability?.version,
          category: capabilityResolutions[i].capability?.category,
          status: capabilityResolutions[i].status,
          resolution: capabilityResolutions[i],
          operationCode: capabilityResolutions[i].capability?.operationCode,
          stepId: stepIdsByCapabilityId[capabilityIds[i].value],
        ),
    ];

    return AssistantWorkflowExecutionPlan.fromDefinition(
      definition: definition,
      requestId: requestId,
      generatedAt: _clock().toUtc(),
      resolvedCapabilities: capabilityResolutions,
      executionNodes: executionNodes,
      resolvedCommands: commandResolutions,
      commandExecutionNodes: commandExecutionNodes,
    );
  }
}
