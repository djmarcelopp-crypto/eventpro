import '../../assistant/models/assistant_idempotency_record.dart';
import '../../assistant/models/assistant_idempotency_status.dart';
import '../../assistant/models/assistant_write_idempotency_key.dart';
import '../../assistant/services/local_assistant_idempotency_service.dart';
import '../data/repositories/quote_repository.dart';
import '../models/quote_status.dart';

/// Complementary persistent lookup for AI-006 Drafts (no new schema).
AssistantIdempotencyCompletedLookup quoteIdempotencyCompletedLookup(
  QuoteRepository repository, {
  DateTime Function()? clock,
}) {
  final now = clock ?? DateTime.now;
  return (AssistantWriteIdempotencyKey key) async {
    final quote = await repository.findById(key.derivedDraftId);
    if (quote == null || quote.status != QuoteStatus.draft) {
      return null;
    }
    return AssistantIdempotencyRecord.fromKey(
      key: key,
      status: AssistantIdempotencyStatus.completed,
      updatedAt: now(),
      resultDraftId: quote.id,
      resultDraftNumber: quote.number,
      executed: true,
      mutatedErp: false,
    );
  };
}
