import '../../models/assistant_idempotency_record.dart';

/// Interchangeable persistence port for idempotency records.
///
/// Must not depend on Drift, Flutter, or Quote modules.
abstract class AssistantIdempotencyStore {
  Future<AssistantIdempotencyRecord?> findByFingerprint(String fingerprint);

  /// Atomically claim [pending] if no conflicting record exists.
  ///
  /// Returns the claimed/existing record. Implementations must document
  /// their atomicity guarantees.
  Future<AssistantIdempotencyRecord> claimPending(
    AssistantIdempotencyRecord pending,
  );

  Future<void> save(AssistantIdempotencyRecord record);
}
