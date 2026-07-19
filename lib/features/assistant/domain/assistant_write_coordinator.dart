import '../models/assistant_execution_context.dart';
import '../models/assistant_write_preparation.dart';
import '../models/assistant_write_request.dart';
import 'write/assistant_write_gateway.dart';

/// Coordinates write-intent preparation and optional gateway execution.
abstract class AssistantWriteCoordinator {
  AssistantWritePreparation prepare({
    required AssistantWriteRequest request,
    required AssistantExecutionContext context,
  });

  /// May invoke [AssistantWriteGateway] only when all AI-006 gates pass.
  Future<AssistantWritePreparation> prepareAndMaybeExecute({
    required AssistantWriteRequest request,
    required AssistantExecutionContext context,
    required bool confirmationSatisfied,
    AssistantWriteGateway? writeGateway,
  });
}
