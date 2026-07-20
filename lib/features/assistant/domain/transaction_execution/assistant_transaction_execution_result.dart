import '../../models/assistant_write_result.dart';
import 'assistant_transaction_execution_metadata.dart';
import 'assistant_transaction_execution_outcome.dart';
import 'assistant_transaction_execution_warning.dart';

/// Outcome of the transaction execution engine (may include a write result).
class AssistantTransactionExecutionResult {
  const AssistantTransactionExecutionResult({
    required this.requestId,
    required this.outcome,
    required this.warnings,
    required this.metadata,
    this.summary,
    this.valid = true,
    this.executed = false,
    this.writeResult,
  });

  final String requestId;
  final AssistantTransactionExecutionOutcome outcome;
  final List<AssistantTransactionExecutionWarning> warnings;
  final AssistantTransactionExecutionMetadata metadata;
  final String? summary;
  final bool valid;
  final bool executed;
  final AssistantWriteResult? writeResult;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'outcome': outcome.name,
        'valid': valid,
        'executed': executed,
        'summary': summary,
        'warnings': warnings.map((w) => w.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
        'writeResult': writeResult == null
            ? null
            : {
                'executed': writeResult!.executed,
                'mutatedErp': writeResult!.mutatedErp,
                'draftId': writeResult!.draftId,
                'draftNumber': writeResult!.draftNumber,
                'summary': writeResult!.summary,
              },
      };
}
