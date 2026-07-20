import '../domain/business/capabilities/assistant_business_capability_constraint.dart';
import '../domain/business/capabilities/assistant_business_capability_id.dart';
import '../domain/business/capabilities/assistant_business_capability_registry.dart';
import '../domain/business/capabilities/assistant_business_capability_resolution.dart';
import '../domain/business/capabilities/assistant_business_capability_resolver.dart';
import '../domain/business/capabilities/assistant_business_capability_warning.dart';
import '../domain/business/capabilities/capability_resolution_status.dart';
import '../domain/workflow/assistant_workflow_context.dart';
import 'local_assistant_business_capability_registry.dart';

/// Validates capability readiness for planning — never invokes gateways.
class LocalAssistantBusinessCapabilityResolver
    implements AssistantBusinessCapabilityResolver {
  LocalAssistantBusinessCapabilityResolver({
    AssistantBusinessCapabilityRegistry? registry,
  }) : _registry =
            registry ?? LocalAssistantBusinessCapabilityRegistry.defaults();

  final AssistantBusinessCapabilityRegistry _registry;

  AssistantBusinessCapabilityRegistry get registry => _registry;

  @override
  AssistantBusinessCapabilityResolution resolve({
    required AssistantBusinessCapabilityId id,
    AssistantWorkflowContext context = const AssistantWorkflowContext(),
    Map<String, String> inputs = const {},
    Set<String> satisfiedDependencies = const {},
    Set<String> resolvedPriorCapabilityIds = const {},
  }) {
    final capability = _registry.find(id);
    if (capability == null) {
      return AssistantBusinessCapabilityResolution(
        capabilityId: id.value,
        status: CapabilityResolutionStatus.notFound,
        warnings: [
          AssistantBusinessCapabilityWarning(
            code: AssistantBusinessCapabilityWarning.notFound,
            message: 'Capability ${id.value} não registrada.',
          ),
        ],
      );
    }

    final warnings = <AssistantBusinessCapabilityWarning>[];
    var hasMissingInput = false;
    var hasUnmetConstraint = false;

    for (final input in capability.inputs) {
      if (!input.required) continue;
      final value = inputs[input.key]?.trim();
      if (value == null || value.isEmpty) {
        hasMissingInput = true;
        warnings.add(
          AssistantBusinessCapabilityWarning(
            code: AssistantBusinessCapabilityWarning.missingInput,
            message: 'Input obrigatório ausente: ${input.key}.',
          ),
        );
      }
    }

    for (final constraint in capability.constraints) {
      final unmet = !_isConstraintMet(
        constraint: constraint,
        context: context,
        satisfiedDependencies: satisfiedDependencies,
        resolvedPriorCapabilityIds: resolvedPriorCapabilityIds,
      );
      if (unmet) {
        hasUnmetConstraint = true;
        warnings.add(
          AssistantBusinessCapabilityWarning(
            code: AssistantBusinessCapabilityWarning.unmetConstraint,
            message: constraint.message ??
                'Restrição não satisfeita: ${constraint.kind.name}/${constraint.key}.',
          ),
        );
      }
    }

    return AssistantBusinessCapabilityResolution(
      capabilityId: id.value,
      capability: capability,
      status: _statusFor(
        hasMissingInput: hasMissingInput,
        hasUnmetConstraint: hasUnmetConstraint,
        warningCount: warnings.length,
      ),
      warnings: List.unmodifiable(warnings),
    );
  }

  @override
  List<AssistantBusinessCapabilityResolution> resolveSequence({
    required List<AssistantBusinessCapabilityId> ids,
    AssistantWorkflowContext initialContext = const AssistantWorkflowContext(),
    Map<String, Map<String, String>> inputsByCapabilityId = const {},
  }) {
    final results = <AssistantBusinessCapabilityResolution>[];
    final satisfied = <String>{
      ...initialContext.values.keys,
    };
    final priorIds = <String>{};
    var context = initialContext;

    for (final id in ids) {
      final resolution = resolve(
        id: id,
        context: context,
        inputs: inputsByCapabilityId[id.value] ?? const {},
        satisfiedDependencies: satisfied,
        resolvedPriorCapabilityIds: priorIds,
      );
      results.add(resolution);

      if (!resolution.ready || resolution.capability == null) {
        continue;
      }

      priorIds.add(id.value);
      for (final output in resolution.capability!.outputs) {
        satisfied.add(output.key);
        // Placeholder marker so requiresContextKey can see planned outputs.
        context = context.put(output.key, true);
      }
    }

    return List.unmodifiable(results);
  }

  static CapabilityResolutionStatus _statusFor({
    required bool hasMissingInput,
    required bool hasUnmetConstraint,
    required int warningCount,
  }) {
    if (warningCount == 0) return CapabilityResolutionStatus.ready;
    if (hasMissingInput && !hasUnmetConstraint) {
      return CapabilityResolutionStatus.missingInput;
    }
    if (hasUnmetConstraint && !hasMissingInput) {
      return CapabilityResolutionStatus.unmetConstraint;
    }
    return CapabilityResolutionStatus.blocked;
  }

  static bool _isConstraintMet({
    required AssistantBusinessCapabilityConstraint constraint,
    required AssistantWorkflowContext context,
    required Set<String> satisfiedDependencies,
    required Set<String> resolvedPriorCapabilityIds,
  }) {
    switch (constraint.kind) {
      case AssistantBusinessCapabilityConstraintKind.requiresContextKey:
        return context.containsKey(constraint.key) ||
            satisfiedDependencies.contains(constraint.key);
      case AssistantBusinessCapabilityConstraintKind
            .requiresSatisfiedDependency:
        return satisfiedDependencies.contains(constraint.key) ||
            context.containsKey(constraint.key);
      case AssistantBusinessCapabilityConstraintKind.requiresPriorCapability:
        return resolvedPriorCapabilityIds.contains(constraint.key);
    }
  }
}
