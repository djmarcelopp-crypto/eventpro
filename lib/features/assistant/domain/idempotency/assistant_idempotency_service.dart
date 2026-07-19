import '../../models/assistant_idempotency_record.dart';
import '../../models/assistant_idempotency_result.dart';
import '../../models/assistant_write_failure_code.dart';
import '../../models/assistant_write_idempotency_key.dart';

/// Dedicated idempotency coordination for controlled writes.
abstract class AssistantIdempotencyService {
  Future<AssistantIdempotencyResult> begin(AssistantWriteIdempotencyKey key);

  Future<AssistantIdempotencyRecord> complete(
    AssistantWriteIdempotencyKey key, {
    required String draftId,
    String? draftNumber,
    required bool mutatedErp,
  });

  Future<AssistantIdempotencyRecord> fail(
    AssistantWriteIdempotencyKey key, {
    required AssistantWriteFailureCode code,
    required String message,
  });

  Future<AssistantIdempotencyRecord> markUncertain(
    AssistantWriteIdempotencyKey key, {
    required String message,
  });

  Future<AssistantIdempotencyRecord?> findByKey(AssistantWriteIdempotencyKey key);
}
