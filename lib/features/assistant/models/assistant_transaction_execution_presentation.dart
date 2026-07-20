import '../domain/transaction_execution/assistant_transaction_execution_result.dart';

/// Natural-language + structured presentation of a transaction execution turn.
class AssistantTransactionExecutionPresentation {
  const AssistantTransactionExecutionPresentation({
    required this.naturalLanguage,
    required this.structured,
    this.warnings = const [],
  });

  final String naturalLanguage;
  final Map<String, Object?> structured;
  final List<String> warnings;

  factory AssistantTransactionExecutionPresentation.fromResult(
    AssistantTransactionExecutionResult result, {
    required String naturalLanguage,
  }) {
    return AssistantTransactionExecutionPresentation(
      naturalLanguage: naturalLanguage,
      structured: result.toDeterministicMap(),
      warnings: result.warnings.map((w) => w.message).toList(growable: false),
    );
  }
}
