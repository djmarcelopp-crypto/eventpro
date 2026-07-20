import '../domain/business/assistant_business_gateway.dart';
import '../domain/business/assistant_business_operation.dart';
import '../domain/business/assistant_business_reference.dart';
import '../domain/business/assistant_business_request.dart';
import '../domain/business/assistant_business_result.dart';
import '../domain/business/assistant_business_status.dart';
import '../domain/workflow/assistant_workflow_business_context.dart';
import '../domain/workflow/assistant_workflow_context.dart';
import '../domain/workflow/assistant_workflow_step.dart';
import '../domain/workflow/assistant_workflow_step_handler.dart';
import '../domain/workflow/assistant_workflow_step_result.dart';
import '../domain/workflow/assistant_workflow_warning.dart';
import '../models/assistant_request.dart';

/// Bridge: WorkflowStep → Business Gateway → StepResult.
///
/// Knows nothing about ERP rules — only maps step params/context to a request.
class AssistantWorkflowBusinessBridge implements AssistantWorkflowStepHandler {
  AssistantWorkflowBusinessBridge({
    required AssistantBusinessGateway gateway,
  }) : _gateway = gateway;

  final AssistantBusinessGateway _gateway;

  @override
  Future<AssistantWorkflowStepResult> execute({
    required AssistantWorkflowStep step,
    required AssistantWorkflowContext context,
    required AssistantRequest request,
  }) async {
    final code = step.params['operation']?.trim();
    if (code == null || code.isEmpty) {
      final warning = const AssistantWorkflowWarning(
        code: AssistantWorkflowWarning.stepFailed,
        message: 'Business step sem param operation.',
      );
      return AssistantWorkflowStepResult(
        step: step,
        success: false,
        interrupt: step.required,
        message: warning.message,
        warnings: [warning],
      );
    }

    final operation = AssistantBusinessOperation(
      code: code,
      label: step.label,
    );
    final businessRequest = AssistantBusinessRequest(
      requestId: request.id,
      operation: operation,
      params: Map<String, String>.from(step.params)..remove('operation'),
      clientReference: _readClient(context, step),
      quoteReference: _readQuote(context, step),
      eventReference: _readEvent(context, step),
      contractReference: _readContract(context, step),
    );

    final result = await _gateway.execute(businessRequest);
    return _toStepResult(step: step, result: result);
  }

  static AssistantWorkflowStepResult _toStepResult({
    required AssistantWorkflowStep step,
    required AssistantBusinessResult result,
  }) {
    final outputs = <String, Object?>{
      AssistantWorkflowBusinessKeys.businessResult: result,
      ...result.outputs,
    };
    if (result.clientReference != null) {
      outputs[AssistantWorkflowBusinessKeys.clientReference] =
          result.clientReference;
    }
    if (result.quoteReference != null) {
      outputs[AssistantWorkflowBusinessKeys.quoteReference] =
          result.quoteReference;
    }
    if (result.eventReference != null) {
      outputs[AssistantWorkflowBusinessKeys.eventReference] =
          result.eventReference;
    }
    if (result.contractReference != null) {
      outputs[AssistantWorkflowBusinessKeys.contractReference] =
          result.contractReference;
    }

    final workflowWarnings = result.warnings
        .map(
          (w) => AssistantWorkflowWarning(
            code: w.code,
            message: w.message,
          ),
        )
        .toList();

    final success = result.valid &&
        result.status == AssistantBusinessStatus.succeeded;

    return AssistantWorkflowStepResult(
      step: step,
      success: success,
      interrupt: !success && step.required,
      message: result.message,
      outputs: outputs,
      warnings: workflowWarnings,
    );
  }

  static ClientReference? _readClient(
    AssistantWorkflowContext context,
    AssistantWorkflowStep step,
  ) {
    final fromContext =
        context[AssistantWorkflowBusinessKeys.clientReference];
    if (fromContext is ClientReference) return fromContext;
    final id = step.params['clientId'];
    if (id != null && id.isNotEmpty) {
      return ClientReference(id: id, label: step.params['clientLabel']);
    }
    return null;
  }

  static QuoteReference? _readQuote(
    AssistantWorkflowContext context,
    AssistantWorkflowStep step,
  ) {
    final fromContext =
        context[AssistantWorkflowBusinessKeys.quoteReference];
    if (fromContext is QuoteReference) return fromContext;
    final id = step.params['quoteId'];
    if (id != null && id.isNotEmpty) {
      return QuoteReference(id: id, label: step.params['quoteLabel']);
    }
    return null;
  }

  static EventReference? _readEvent(
    AssistantWorkflowContext context,
    AssistantWorkflowStep step,
  ) {
    final fromContext =
        context[AssistantWorkflowBusinessKeys.eventReference];
    if (fromContext is EventReference) return fromContext;
    final id = step.params['eventId'];
    if (id != null && id.isNotEmpty) {
      return EventReference(id: id, label: step.params['eventLabel']);
    }
    return null;
  }

  static ContractReference? _readContract(
    AssistantWorkflowContext context,
    AssistantWorkflowStep step,
  ) {
    final fromContext =
        context[AssistantWorkflowBusinessKeys.contractReference];
    if (fromContext is ContractReference) return fromContext;
    final id = step.params['contractId'];
    if (id != null && id.isNotEmpty) {
      return ContractReference(id: id, label: step.params['contractLabel']);
    }
    return null;
  }
}
