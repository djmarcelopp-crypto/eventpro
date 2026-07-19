import 'assistant_execution_context.dart';
import 'assistant_write_authorization_status.dart';
import 'assistant_write_result.dart';
import 'assistant_write_validation_result.dart';

/// Bundle produced by the write coordinator — preparation only, never execution.
class AssistantWritePreparation {
  const AssistantWritePreparation({
    required this.writeResult,
    required this.writeValidation,
    required this.writeAuthorization,
    required this.context,
    this.writeWarnings = const [],
  });

  final AssistantWriteResult writeResult;
  final AssistantWriteValidationResult writeValidation;
  final AssistantWriteAuthorizationStatus writeAuthorization;
  final List<String> writeWarnings;

  /// Execution context used for preparation correlation (never mutated).
  final AssistantExecutionContext context;

  bool get executed => writeResult.executed;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWritePreparation &&
            other.writeResult == writeResult &&
            other.writeValidation == writeValidation &&
            other.writeAuthorization == writeAuthorization &&
            _listEquals(other.writeWarnings, writeWarnings) &&
            other.context == context;
  }

  @override
  int get hashCode => Object.hash(
        writeResult,
        writeValidation,
        writeAuthorization,
        Object.hashAll(writeWarnings),
        context,
      );

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
