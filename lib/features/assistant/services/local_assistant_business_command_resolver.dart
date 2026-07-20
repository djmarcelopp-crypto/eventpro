import '../domain/business/capabilities/assistant_business_capability_constraint.dart';
import '../domain/business/capabilities/assistant_business_capability_registry.dart';
import '../domain/business/commands/assistant_business_command_id.dart';
import '../domain/business/commands/assistant_business_command_registry.dart';
import '../domain/business/commands/assistant_business_command_resolution.dart';
import '../domain/business/commands/assistant_business_command_resolution_status.dart';
import '../domain/business/commands/assistant_business_command_resolver.dart';
import '../domain/business/commands/assistant_business_command_status.dart';
import '../domain/workflow/assistant_workflow_context.dart';
import 'local_assistant_business_capability_registry.dart';
import 'local_assistant_business_command_registry.dart';

/// Validates command readiness for planning — never invokes gateways.
///
/// Resolves the matching AI-018 Capability solely via command [operationCode].
class LocalAssistantBusinessCommandResolver
    implements AssistantBusinessCommandResolver {
  LocalAssistantBusinessCommandResolver({
    AssistantBusinessCommandRegistry? registry,
    AssistantBusinessCapabilityRegistry? capabilityRegistry,
  })  : _registry =
            registry ?? LocalAssistantBusinessCommandRegistry.defaults(),
        _capabilities = capabilityRegistry ??
            LocalAssistantBusinessCapabilityRegistry.defaults();

  final AssistantBusinessCommandRegistry _registry;
  final AssistantBusinessCapabilityRegistry _capabilities;

  AssistantBusinessCommandRegistry get registry => _registry;

  AssistantBusinessCapabilityRegistry get capabilityRegistry => _capabilities;

  @override
  AssistantBusinessCommandResolution resolve({
    required AssistantBusinessCommandId id,
    AssistantWorkflowContext context = const AssistantWorkflowContext(),
    Map<String, String> parameters = const {},
    Set<String> satisfiedOutputs = const {},
  }) {
    final command = _registry.find(id);
    if (command == null) {
      return AssistantBusinessCommandResolution(
        commandId: id.value,
        resolutionStatus: AssistantBusinessCommandResolutionStatus.notFound,
        commandStatus: AssistantBusinessCommandStatus.blocked,
        messages: ['Command ${id.value} não registrado.'],
      );
    }

    final messages = <String>[];
    var missingParameter = false;

    for (final parameter in command.parameters) {
      if (!parameter.required) continue;
      final value = parameters[parameter.key]?.trim();
      if (value == null || value.isEmpty) {
        missingParameter = true;
        messages.add('Parâmetro obrigatório ausente: ${parameter.key}.');
      }
    }

    final operationCode = command.metadata.operationCode?.trim();
    if (operationCode == null || operationCode.isEmpty) {
      messages.add('Command ${id.value} sem operationCode (fonte de verdade).');
      return AssistantBusinessCommandResolution(
        commandId: id.value,
        command: command,
        resolutionStatus: AssistantBusinessCommandResolutionStatus.blocked,
        commandStatus: AssistantBusinessCommandStatus.blocked,
        messages: List.unmodifiable(messages),
      );
    }

    final capability = _capabilities.findByOperationCode(operationCode);
    if (capability == null) {
      messages.add(
        'Nenhuma Capability para operationCode "$operationCode".',
      );
      return AssistantBusinessCommandResolution(
        commandId: id.value,
        command: command,
        resolutionStatus: AssistantBusinessCommandResolutionStatus.blocked,
        commandStatus: AssistantBusinessCommandStatus.blocked,
        messages: List.unmodifiable(messages),
      );
    }

    for (final constraint in capability.constraints) {
      if (constraint.kind !=
          AssistantBusinessCapabilityConstraintKind.requiresSatisfiedDependency) {
        continue;
      }
      final ok = satisfiedOutputs.contains(constraint.key) ||
          context.containsKey(constraint.key);
      if (!ok) {
        messages.add(
          constraint.message ??
              'Dependência não satisfeita para command: ${constraint.key}.',
        );
        return AssistantBusinessCommandResolution(
          commandId: id.value,
          command: command,
          resolvedCapability: capability,
          resolutionStatus: AssistantBusinessCommandResolutionStatus.blocked,
          commandStatus: AssistantBusinessCommandStatus.blocked,
          messages: List.unmodifiable(messages),
        );
      }
    }

    if (missingParameter) {
      return AssistantBusinessCommandResolution(
        commandId: id.value,
        command: command,
        resolvedCapability: capability,
        resolutionStatus:
            AssistantBusinessCommandResolutionStatus.missingParameter,
        commandStatus: AssistantBusinessCommandStatus.blocked,
        messages: List.unmodifiable(messages),
      );
    }

    return AssistantBusinessCommandResolution(
      commandId: id.value,
      command: command,
      resolvedCapability: capability,
      resolutionStatus: AssistantBusinessCommandResolutionStatus.ready,
      commandStatus: AssistantBusinessCommandStatus.ready,
      messages: List.unmodifiable(messages),
    );
  }

  @override
  List<AssistantBusinessCommandResolution> resolveSequence({
    required List<AssistantBusinessCommandId> ids,
    AssistantWorkflowContext initialContext = const AssistantWorkflowContext(),
    Map<String, Map<String, String>> parametersByCommandId = const {},
  }) {
    final results = <AssistantBusinessCommandResolution>[];
    final satisfied = <String>{...initialContext.values.keys};
    var context = initialContext;

    for (final id in ids) {
      final resolution = resolve(
        id: id,
        context: context,
        parameters: parametersByCommandId[id.value] ?? const {},
        satisfiedOutputs: satisfied,
      );
      results.add(resolution);

      if (!resolution.ready || resolution.command == null) continue;

      for (final result in resolution.command!.results) {
        satisfied.add(result.key);
        context = context.put(result.key, true);
      }
    }

    return List.unmodifiable(results);
  }
}
