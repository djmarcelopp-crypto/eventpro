import 'dart:async';

import '../domain/idempotency/assistant_idempotency_store.dart';
import '../models/assistant_idempotency_record.dart';
import '../models/assistant_idempotency_status.dart';

/// Process-local idempotency store with synchronized claim.
///
/// Atomicity: **single isolate only**. Concurrent [claimPending] for the same
/// fingerprint is serialized via an in-process lock. Cross-isolate / cold-start
/// pending claims require a future dedicated table (not in AI-007).
///
/// Completed outcomes should also be recoverable via complementary resource
/// lookup (deterministic Quote id) — this store alone is not the full story.
class LocalAssistantIdempotencyStore implements AssistantIdempotencyStore {
  LocalAssistantIdempotencyStore();

  final Map<String, AssistantIdempotencyRecord> _records = {};
  final Map<String, Future<void>> _locks = {};

  @override
  Future<AssistantIdempotencyRecord?> findByFingerprint(String fingerprint) async {
    return _records[fingerprint];
  }

  @override
  Future<AssistantIdempotencyRecord> claimPending(
    AssistantIdempotencyRecord pending,
  ) async {
    return _withLock(pending.fingerprint, () async {
      final existing = _records[pending.fingerprint];
      if (existing != null) {
        return existing;
      }
      _records[pending.fingerprint] = pending;
      return pending;
    });
  }

  @override
  Future<void> save(AssistantIdempotencyRecord record) async {
    await _withLock(record.fingerprint, () async {
      _records[record.fingerprint] = record;
    });
  }

  Future<T> _withLock<T>(String fingerprint, Future<T> Function() body) async {
    while (_locks.containsKey(fingerprint)) {
      await _locks[fingerprint];
    }
    final completer = Completer<void>();
    _locks[fingerprint] = completer.future;
    try {
      return await body();
    } finally {
      _locks.remove(fingerprint);
      completer.complete();
    }
  }

  /// Test helper.
  Map<String, AssistantIdempotencyRecord> get debugSnapshot =>
      Map.unmodifiable(_records);

  bool get hasPending =>
      _records.values.any((r) => r.status == AssistantIdempotencyStatus.pending);
}
