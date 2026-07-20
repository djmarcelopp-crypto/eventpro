import '../../models/assistant_transaction_execution_presentation.dart';
import 'assistant_transaction_execution_result.dart';

/// Formats transaction execution outcomes for [AssistantResponse].
abstract class AssistantTransactionExecutionFormatter {
  AssistantTransactionExecutionPresentation format(
    AssistantTransactionExecutionResult result,
  );
}
