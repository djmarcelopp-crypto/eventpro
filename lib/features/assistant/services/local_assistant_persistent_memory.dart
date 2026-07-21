import '../domain/memory/assistant_memory_entry.dart';
import '../domain/memory/assistant_memory_id.dart';
import '../domain/memory/assistant_memory_metadata.dart';
import '../domain/memory/assistant_memory_observer.dart';
import '../domain/memory/assistant_memory_policy.dart';
import '../domain/memory/assistant_memory_reference.dart';
import '../domain/memory/assistant_memory_result.dart';
import '../domain/memory/assistant_memory_search.dart';
import '../domain/memory/assistant_memory_type.dart';
import '../domain/memory/assistant_persistent_memory.dart';

/// In-memory Persistent Memory Engine (AI-024 CP-3).
///
/// No Drift, SQLite, vector store, embeddings, HTTP, or LLM.
class LocalAssistantPersistentMemory implements AssistantPersistentMemory {
  LocalAssistantPersistentMemory({
    AssistantMemoryPolicy? policy,
    AssistantMemoryObserver? observer,
    DateTime Function()? clock,
    String Function()? idFactory,
  })  : _policy = policy ?? AssistantMemoryPolicy.defaults,
        _evaluator = AssistantMemoryPolicyEvaluator(
          policy: policy ?? AssistantMemoryPolicy.defaults,
        ),
        _observer = observer ?? const NoopAssistantMemoryObserver(),
        _clock = clock ?? DateTime.now,
        _idFactory = idFactory ?? _defaultIdFactory;

  final AssistantMemoryPolicy _policy;
  final AssistantMemoryPolicyEvaluator _evaluator;
  final AssistantMemoryObserver _observer;
  final DateTime Function() _clock;
  final String Function() _idFactory;

  final Map<String, AssistantMemoryEntry> _byId = {};
  /// Composite key: scope|key → id (for replaceSameKey).
  final Map<String, String> _idByScopeKey = {};
  int _seq = 0;

  static String _defaultIdFactory() =>
      'mem-${DateTime.now().toUtc().microsecondsSinceEpoch}';

  AssistantMemoryPolicy get policy => _policy;

  int get length => _byId.length;

  /// Synchronous search for Context Engine integration (same rules as [search]).
  AssistantMemoryResult searchSync(AssistantMemorySearch query) {
    _applyExpirations();
    final matched = _filter(
      types: query.types,
      scopes: query.scopes,
      sessionId: query.sessionId,
      correlationId: query.correlationId,
      keys: query.keys,
      tags: query.tags,
      includeArchived: query.includeArchived,
    );
    matched.sort((a, b) {
      final byPriority = b.metadata.priority.compareTo(a.metadata.priority);
      if (byPriority != 0) return byPriority;
      return b.updatedAt.compareTo(a.updatedAt);
    });
    final limited = matched.take(query.limit).toList(growable: false);
    return AssistantMemoryResult(
      entries: limited,
      totalMatched: matched.length,
      query: query,
    );
  }

  @override
  Future<AssistantMemoryEntry> remember(AssistantMemoryEntry entry) async {
    final now = _clock().toUtc();
    final scopeKey = _scopeKey(entry.scope, entry.key);
    final existingId = _idByScopeKey[scopeKey];
    final existing = existingId == null ? null : _byId[existingId];

    final decision = _evaluator.evaluateReplacement(
      existing: existing,
      incoming: entry,
    );
    if (!decision.allowed) {
      _record(
        operation: 'remember.reject',
        entry: entry,
        reason: decision.reason,
      );
      if (existing != null) return existing;
    }

    if (decision.action == AssistantMemoryPolicyAction.replace &&
        existing != null) {
      final updated = existing.copyWith(
        type: entry.type,
        scope: entry.scope,
        key: entry.key,
        value: entry.value,
        references: entry.references,
        metadata: entry.metadata,
        status: AssistantMemoryStatus.active,
        updatedAt: now,
      );
      _byId[existing.id.value] = updated;
      _record(
        operation: 'remember.replace',
        entry: updated,
        reason: decision.reason,
      );
      return updated;
    }

    _evictIfNeeded(entry.scope);

    final id = entry.id.value.isEmpty
        ? AssistantMemoryId('${_idFactory()}-${_seq++}')
        : entry.id;
    final stored = AssistantMemoryEntry(
      id: id,
      type: entry.type,
      scope: entry.scope,
      key: entry.key,
      value: entry.value,
      references: entry.references,
      metadata: entry.metadata,
      status: AssistantMemoryStatus.active,
      createdAt:
          entry.createdAt.isUtc ? entry.createdAt : entry.createdAt.toUtc(),
      updatedAt: now,
    );
    _byId[id.value] = stored;
    _idByScopeKey[scopeKey] = id.value;
    _record(operation: 'remember', entry: stored);
    return stored;
  }

  @override
  Future<bool> forget(AssistantMemoryId id) async {
    final existing = _byId[id.value];
    if (existing == null) return false;
    final now = _clock().toUtc();
    final forgotten = existing.copyWith(
      status: AssistantMemoryStatus.forgotten,
      updatedAt: now,
    );
    _byId[id.value] = forgotten;
    _idByScopeKey.remove(_scopeKey(existing.scope, existing.key));
    _record(operation: 'forget', entry: forgotten);
    return true;
  }

  @override
  Future<AssistantMemoryResult> search(AssistantMemorySearch query) async {
    return searchSync(query);
  }

  @override
  Future<AssistantMemoryEntry?> find(AssistantMemoryId id) async {
    _applyExpirations();
    final entry = _byId[id.value];
    if (entry == null) return null;
    if (entry.status == AssistantMemoryStatus.forgotten) return null;
    return entry;
  }

  @override
  Future<AssistantMemoryEntry?> update(AssistantMemoryEntry entry) async {
    final existing = _byId[entry.id.value];
    if (existing == null) return null;
    final now = _clock().toUtc();
    final updated = entry.copyWith(updatedAt: now);
    _byId[entry.id.value] = updated;
    _idByScopeKey[_scopeKey(updated.scope, updated.key)] = updated.id.value;
    _record(operation: 'update', entry: updated);
    return updated;
  }

  @override
  Future<AssistantMemoryEntry?> archive(AssistantMemoryId id) async {
    final existing = _byId[id.value];
    if (existing == null) return null;
    final now = _clock().toUtc();
    final archived = existing.copyWith(
      status: AssistantMemoryStatus.archived,
      updatedAt: now,
    );
    _byId[id.value] = archived;
    _record(operation: 'archive', entry: archived);
    return archived;
  }

  @override
  Future<AssistantMemoryResult> list({
    List<AssistantMemoryType> types = const [],
    List<AssistantMemoryScope> scopes = const [],
    String? sessionId,
    bool includeArchived = false,
    int limit = 50,
  }) async {
    return searchSync(
      AssistantMemorySearch(
        types: types,
        scopes: scopes,
        sessionId: sessionId,
        includeArchived: includeArchived,
        limit: limit,
      ),
    );
  }

  /// Convenience: remember a well-known last-* key.
  Future<AssistantMemoryEntry> rememberLast({
    required String key,
    required String value,
    required AssistantMemoryType type,
    required AssistantMemoryScope scope,
    AssistantMemoryMetadata metadata = const AssistantMemoryMetadata(),
    List<AssistantMemoryReference> references = const [],
  }) {
    final now = _clock().toUtc();
    return remember(
      AssistantMemoryEntry(
        id: AssistantMemoryId(_idFactory()),
        type: type,
        scope: scope,
        key: key,
        value: value,
        references: references,
        metadata: metadata,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  void clear() {
    _byId.clear();
    _idByScopeKey.clear();
  }

  String _scopeKey(AssistantMemoryScope scope, String key) =>
      '${scope.name}|$key';

  void _evictIfNeeded(AssistantMemoryScope scope) {
    final inScope = _byId.values
        .where(
          (e) =>
              e.scope == scope && e.status == AssistantMemoryStatus.active,
        )
        .toList();
    final decision =
        _evaluator.evaluateCapacity(currentCount: inScope.length);
    if (decision.action != AssistantMemoryPolicyAction.evict) return;

    inScope.sort((a, b) {
      final byPriority = a.metadata.priority.compareTo(b.metadata.priority);
      if (byPriority != 0) return byPriority;
      return a.updatedAt.compareTo(b.updatedAt);
    });
    final victim = inScope.first;
    final now = _clock().toUtc();
    _byId[victim.id.value] = victim.copyWith(
      status: AssistantMemoryStatus.archived,
      updatedAt: now,
    );
    _idByScopeKey.remove(_scopeKey(victim.scope, victim.key));
    _record(
      operation: 'evict',
      entry: victim,
      reason: decision.reason,
    );
  }

  void _applyExpirations() {
    final now = _clock().toUtc();
    for (final entry in _byId.values.toList(growable: false)) {
      if (entry.status != AssistantMemoryStatus.active) continue;
      final decision = _evaluator.evaluateExpiration(entry, now: now);
      if (decision.action == AssistantMemoryPolicyAction.archive) {
        _byId[entry.id.value] = entry.copyWith(
          status: AssistantMemoryStatus.archived,
          updatedAt: now,
        );
        _record(
          operation: 'expire.archive',
          entry: entry,
          reason: decision.reason,
        );
      } else if (decision.action == AssistantMemoryPolicyAction.expire) {
        _byId[entry.id.value] = entry.copyWith(
          status: AssistantMemoryStatus.expired,
          updatedAt: now,
        );
        _record(
          operation: 'expire',
          entry: entry,
          reason: decision.reason,
        );
      }
    }
  }

  List<AssistantMemoryEntry> _filter({
    List<AssistantMemoryType> types = const [],
    List<AssistantMemoryScope> scopes = const [],
    String? sessionId,
    String? correlationId,
    List<String> keys = const [],
    List<String> tags = const [],
    bool includeArchived = false,
  }) {
    return _byId.values.where((e) {
      if (e.status == AssistantMemoryStatus.forgotten) return false;
      if (e.status == AssistantMemoryStatus.expired) return false;
      if (!includeArchived && e.status == AssistantMemoryStatus.archived) {
        return false;
      }
      if (types.isNotEmpty && !types.contains(e.type)) return false;
      if (scopes.isNotEmpty && !scopes.contains(e.scope)) return false;
      if (sessionId != null && e.metadata.sessionId != sessionId) {
        return false;
      }
      if (correlationId != null &&
          e.metadata.correlationId != correlationId) {
        return false;
      }
      if (keys.isNotEmpty && !keys.contains(e.key)) return false;
      if (tags.isNotEmpty &&
          !tags.any((t) => e.metadata.tags.contains(t))) {
        return false;
      }
      return true;
    }).toList();
  }

  void _record({
    required String operation,
    required AssistantMemoryEntry entry,
    String? reason,
  }) {
    _observer.record(
      AssistantMemoryOperationRecord(
        operation: operation,
        timestamp: _clock().toUtc(),
        origin: entry.metadata.origin,
        reason: reason ?? entry.metadata.reason,
        confidence: entry.metadata.confidence,
        scope: entry.scope.name,
        memoryId: entry.id.value,
        details: [
          'key:${entry.key}',
          'type:${entry.type.name}',
          'status:${entry.status.name}',
        ],
      ),
    );
  }
}
