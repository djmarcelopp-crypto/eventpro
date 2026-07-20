import '../domain/workflow/assistant_workflow_formatter.dart';
import '../domain/workflow/assistant_workflow_result.dart';
import '../models/assistant_workflow_presentation.dart';

class LocalAssistantWorkflowFormatter implements AssistantWorkflowFormatter {
  const LocalAssistantWorkflowFormatter();

  @override
  AssistantWorkflowPresentation format(AssistantWorkflowResult result) {
    final nl = result.summary ??
        (result.completed
            ? 'Workflow concluído.'
            : result.interrupted
                ? 'Workflow interrompido.'
                : 'Workflow processado.');
    return AssistantWorkflowPresentation.fromResult(
      result,
      naturalLanguage: nl,
    );
  }
}
