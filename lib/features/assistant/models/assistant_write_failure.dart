import 'assistant_write_failure_code.dart';

/// Structured write failure — never contains secrets or raw ERP entities.
class AssistantWriteFailure {
  const AssistantWriteFailure({
    required this.code,
    required this.message,
    this.retryable = false,
    this.uncertain = false,
  });

  final AssistantWriteFailureCode code;
  final String message;
  final bool retryable;
  final bool uncertain;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteFailure &&
            other.code == code &&
            other.message == message &&
            other.retryable == retryable &&
            other.uncertain == uncertain;
  }

  @override
  int get hashCode => Object.hash(code, message, retryable, uncertain);
}
