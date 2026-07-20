import '../../models/assistant_execution_context.dart';
import '../../models/assistant_write_result.dart';
import '../write/assistant_write_gateway.dart';
import 'assistant_transaction_execution_request.dart';
import 'assistant_transaction_execution_result.dart';

/// Executes a validated transaction request against the write pipeline.
abstract class AssistantTransactionExecutionGateway {
  Future<AssistantTransactionExecutionResult> execute({
    required AssistantTransactionExecutionRequest request,
    required AssistantExecutionContext context,
    required AssistantWriteGateway? writeGateway,
    Future<AssistantWriteResult> Function({
      required AssistantTransactionExecutionRequest request,
      required AssistantExecutionContext context,
      required AssistantWriteGateway? writeGateway,
    })? writeExecutor,
  });
}
