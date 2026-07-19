import '../models/assistant_execution_context.dart';
import '../models/assistant_write_preparation.dart';
import '../models/assistant_write_request.dart';

/// Coordinates write-intent preparation — never executes ERP commands.
abstract class AssistantWriteCoordinator {
  AssistantWritePreparation prepare({
    required AssistantWriteRequest request,
    required AssistantExecutionContext context,
  });
}
