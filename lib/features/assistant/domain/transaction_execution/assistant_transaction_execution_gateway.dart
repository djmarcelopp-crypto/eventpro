import '../../models/assistant_execution_context.dart';
import '../write/assistant_write_gateway.dart';
import 'assistant_transaction_execution_request.dart';
import 'assistant_transaction_execution_result.dart';

/// Executes a validated transaction request against the write pipeline.
///
/// AR-002: write infrastructure is injected on the local implementation —
/// the port no longer accepts WriteGateway / writeExecutor callbacks.
abstract class AssistantTransactionExecutionGateway {
  Future<AssistantTransactionExecutionResult> execute({
    required AssistantTransactionExecutionRequest request,
    required AssistantExecutionContext context,
  });
}
