import '../../workflow/assistant_workflow_context.dart';
import 'assistant_business_capability_id.dart';
import 'assistant_business_capability_resolution.dart';

/// Locates and validates capabilities for planning — never executes.
abstract class AssistantBusinessCapabilityResolver {
  AssistantBusinessCapabilityResolution resolve({
    required AssistantBusinessCapabilityId id,
    AssistantWorkflowContext context = const AssistantWorkflowContext(),
    Map<String, String> inputs = const {},
    Set<String> satisfiedDependencies = const {},
    Set<String> resolvedPriorCapabilityIds = const {},
  });

  /// Resolves a sequence, simulating dependency satisfaction from outputs.
  List<AssistantBusinessCapabilityResolution> resolveSequence({
    required List<AssistantBusinessCapabilityId> ids,
    AssistantWorkflowContext initialContext = const AssistantWorkflowContext(),
    Map<String, Map<String, String>> inputsByCapabilityId = const {},
  });
}
