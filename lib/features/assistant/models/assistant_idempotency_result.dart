import 'assistant_idempotency_record.dart';

/// Outcome of attempting to begin an idempotent operation.
enum AssistantIdempotencyBeginDecision {
  /// Caller may proceed to mutate.
  proceed,

  /// Prior completed result must be returned; do not mutate.
  replayCompleted,

  /// Another execution is in flight; do not mutate.
  blockedPending,

  /// Prior failure recorded; caller may retry after explicit fail handling.
  retryAfterFailure,

  /// Prior uncertain outcome; do not auto-mutate — recover via resource lookup.
  blockedUncertain,
}

class AssistantIdempotencyResult {
  const AssistantIdempotencyResult({
    required this.decision,
    required this.record,
  });

  final AssistantIdempotencyBeginDecision decision;
  final AssistantIdempotencyRecord record;

  bool get mayMutate => decision == AssistantIdempotencyBeginDecision.proceed;

  bool get shouldReplay =>
      decision == AssistantIdempotencyBeginDecision.replayCompleted;
}
