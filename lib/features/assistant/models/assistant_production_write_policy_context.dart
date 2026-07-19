import 'assistant_execution_context.dart';
import 'assistant_write_authorization_status.dart';
import 'assistant_write_preparation.dart';
import 'assistant_write_request.dart';

/// Inputs for evaluating a production write policy.
class AssistantProductionWritePolicyContext {
  const AssistantProductionWritePolicyContext({
    required this.request,
    required this.executionContext,
    required this.preparation,
    required this.confirmationSatisfied,
    required this.adapterAvailable,
    required this.adapterName,
  });

  final AssistantWriteRequest request;
  final AssistantExecutionContext executionContext;
  final AssistantWritePreparation preparation;
  final bool confirmationSatisfied;
  final bool adapterAvailable;
  final String adapterName;

  AssistantWriteAuthorizationStatus get authorizationStatus =>
      preparation.writeAuthorization;
}
