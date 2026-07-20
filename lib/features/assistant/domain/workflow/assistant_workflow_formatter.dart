import '../../models/assistant_workflow_presentation.dart';
import 'assistant_workflow_result.dart';

/// Formats workflow results for [AssistantResponse].
abstract class AssistantWorkflowFormatter {
  AssistantWorkflowPresentation format(AssistantWorkflowResult result);
}
