import '../../workflow/assistant_workflow_context.dart';
import 'assistant_business_command_id.dart';
import 'assistant_business_command_resolution.dart';

/// Locates and validates commands for planning — never executes.
abstract class AssistantBusinessCommandResolver {
  AssistantBusinessCommandResolution resolve({
    required AssistantBusinessCommandId id,
    AssistantWorkflowContext context = const AssistantWorkflowContext(),
    Map<String, String> parameters = const {},
    Set<String> satisfiedOutputs = const {},
  });

  /// Resolves a sequence, simulating produced outputs between commands.
  List<AssistantBusinessCommandResolution> resolveSequence({
    required List<AssistantBusinessCommandId> ids,
    AssistantWorkflowContext initialContext = const AssistantWorkflowContext(),
    Map<String, Map<String, String>> parametersByCommandId = const {},
  });
}
