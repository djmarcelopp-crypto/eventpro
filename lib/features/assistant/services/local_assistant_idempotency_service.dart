import 'dart:async';

import '../domain/idempotency/assistant_idempotency_service.dart';
import '../domain/idempotency/assistant_idempotency_store.dart';
import '../models/assistant_idempotency_record.dart';
import '../models/assistant_idempotency_result.dart';
import '../models/assistant_idempotency_status.dart';
import '../models/assistant_write_failure_code.dart';
import '../models/assistant_write_idempotency_key.dart';
import 'local_assistant_idempotency_store.dart';

/// Optional complementary lookup for completed resources (e.g. Quote by derived id).
///
/// Returns a completed record when the ERP already holds the resource — preserves
/// AI-006 Drafts across process restarts without a dedicated idempotency table.
typedef AssistantIdempotencyCompletedLookup = Future<AssistantIdempotencyRecord?>
    Function(AssistantWriteIdempotencyKey key);

/// Local idempotency service: process-local claims + optional persistent replay.
class LocalAssistantIdempotencyService implements AssistantIdempotencyService {
  LocalAssistantIdempotencyService({
    AssistantIdempotencyStore? store,
    AssistantIdempotencyCompletedLookup? completedLookup,
    DateTime Function()? clock,
  })  : _store = store ?? LocalAssistantIdempotencyStore(),
        _completedLookup = completedLookup,
        _clock = clock ?? DateTime.now;

  final AssistantIdempotencyStore _store;
  final AssistantIdempotencyCompletedLookup? _completedLookup;
  final DateTime Function() _clock;

  /// In-flight waiters for concurrent begin with the same fingerprint.
  final Map<String, Completer<AssistantIdempotencyRecord>> _inflight = {};

  @override
  Future<AssistantIdempotencyResult> begin(AssistantWriteIdempotencyKey key) async {
    if (!key.isValid) {
      throw ArgumentError('Idempotency key inválida');
    }

    final fingerprint = key.auditFingerprint;

    // Persistent complementary lookup (AI-006 Drafts).
    final persisted = await _completedLookup?.call(key);
    if (persisted != null &&
        persisted.status == AssistantIdempotencyStatus.completed) {
      await _store.save(persisted);
      return AssistantIdempotencyResult(
        decision: AssistantIdempotencyBeginDecision.replayCompleted,
        record: persisted,
      );
    }

    final existing = await _store.findByFingerprint(fingerprint);
    if (existing != null) {
      return _decideFromExisting(existing, key);
    }

    // Concurrent claim: if another begin is in flight, wait then replay.
    if (_inflight.containsKey(fingerprint)) {
      final finished = await _inflight[fingerprint]!.future;
      return _decideFromExisting(finished, key);
    }

    final claimCompleter = Completer<AssistantIdempotencyRecord>();
    _inflight[fingerprint] = claimCompleter;

    try {
      final pending = AssistantIdempotencyRecord.fromKey(
        key: key,
        status: AssistantIdempotencyStatus.pending,
        updatedAt: _clock(),
      );
      final claimed = await _store.claimPending(pending);
      if (claimed.status != AssistantIdempotencyStatus.pending ||
          claimed.fingerprint != fingerprint) {
        claimCompleter.complete(claimed);
        return _decideFromExisting(claimed, key);
      }
      // Leave completer open until complete/fail/uncertain so waiters join.
      return AssistantIdempotencyResult(
        decision: AssistantIdempotencyBeginDecision.proceed,
        record: claimed,
      );
    } catch (error) {
      _inflight.remove(fingerprint);
      if (!claimCompleter.isCompleted) {
        claimCompleter.completeError(error);
      }
      rethrow;
    }
  }

  @override
  Future<AssistantIdempotencyRecord> complete(
    AssistantWriteIdempotencyKey key, {
    required String draftId,
    String? draftNumber,
    required bool mutatedErp,
  }) async {
    final now = _clock();
    final record = AssistantIdempotencyRecord.fromKey(
      key: key,
      status: AssistantIdempotencyStatus.completed,
      updatedAt: now,
      resultDraftId: draftId,
      resultDraftNumber: draftNumber,
      executed: true,
      mutatedErp: mutatedErp,
    );
    await _store.save(record);
    _releaseInflight(key.auditFingerprint, record);
    return record;
  }

  @override
  Future<AssistantIdempotencyRecord> fail(
    AssistantWriteIdempotencyKey key, {
    required AssistantWriteFailureCode code,
    required String message,
  }) async {
    final record = AssistantIdempotencyRecord.fromKey(
      key: key,
      status: AssistantIdempotencyStatus.failed,
      updatedAt: _clock(),
      failureCode: code,
      failureMessage: message,
    );
    await _store.save(record);
    _releaseInflight(key.auditFingerprint, record);
    return record;
  }

  @override
  Future<AssistantIdempotencyRecord> markUncertain(
    AssistantWriteIdempotencyKey key, {
    required String message,
  }) async {
    final record = AssistantIdempotencyRecord.fromKey(
      key: key,
      status: AssistantIdempotencyStatus.uncertain,
      updatedAt: _clock(),
      failureCode: AssistantWriteFailureCode.uncertainOutcome,
      failureMessage: message,
    );
    await _store.save(record);
    _releaseInflight(key.auditFingerprint, record);
    return record;
  }

  @override
  Future<AssistantIdempotencyRecord?> findByKey(
    AssistantWriteIdempotencyKey key,
  ) async {
    final local = await _store.findByFingerprint(key.auditFingerprint);
    if (local != null) return local;
    return _completedLookup?.call(key);
  }

  Future<AssistantIdempotencyResult> _decideFromExisting(
    AssistantIdempotencyRecord existing,
    AssistantWriteIdempotencyKey key,
  ) async {
    switch (existing.status) {
      case AssistantIdempotencyStatus.completed:
        return AssistantIdempotencyResult(
          decision: AssistantIdempotencyBeginDecision.replayCompleted,
          record: existing,
        );
      case AssistantIdempotencyStatus.pending:
        if (_inflight.containsKey(existing.fingerprint)) {
          final finished = await _inflight[existing.fingerprint]!.future;
          return _decideFromExisting(finished, key);
        }
        return AssistantIdempotencyResult(
          decision: AssistantIdempotencyBeginDecision.blockedPending,
          record: existing,
        );
      case AssistantIdempotencyStatus.failed:
        // Allow a new claim after failure (explicit retry).
        final pending = AssistantIdempotencyRecord.fromKey(
          key: key,
          status: AssistantIdempotencyStatus.pending,
          updatedAt: _clock(),
        );
        await _store.save(pending);
        return AssistantIdempotencyResult(
          decision: AssistantIdempotencyBeginDecision.proceed,
          record: pending,
        );
      case AssistantIdempotencyStatus.uncertain:
        // Prefer persistent recovery if Draft appeared after timeout.
        final recovered = await _completedLookup?.call(key);
        if (recovered != null &&
            recovered.status == AssistantIdempotencyStatus.completed) {
          await _store.save(recovered);
          return AssistantIdempotencyResult(
            decision: AssistantIdempotencyBeginDecision.replayCompleted,
            record: recovered,
          );
        }
        return AssistantIdempotencyResult(
          decision: AssistantIdempotencyBeginDecision.blockedUncertain,
          record: existing,
        );
    }
  }

  void _releaseInflight(String fingerprint, AssistantIdempotencyRecord record) {
    final completer = _inflight.remove(fingerprint);
    if (completer != null && !completer.isCompleted) {
      completer.complete(record);
    }
  }
}
