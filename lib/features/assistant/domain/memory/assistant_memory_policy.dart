import 'assistant_memory_entry.dart';

/// Policy infrastructure for memory lifecycle (AI-024 CP-7).
///
/// Contracts / evaluation only — no durable persistence.
class AssistantMemoryPolicy {
  const AssistantMemoryPolicy({
    this.defaultTtl,
    this.maxEntriesPerScope = 200,
    this.replaceSameKey = true,
    this.archiveOnExpire = true,
    this.minRetention,
    this.priorityFloor = 0,
  });

  /// Default time-to-live when entry has no [AssistantMemoryMetadata.expiresAt].
  final Duration? defaultTtl;

  /// Soft cap used by replacement policy (in-memory engines).
  final int maxEntriesPerScope;

  /// When true, remembering the same key+scope replaces the previous entry.
  final bool replaceSameKey;

  /// When evaluating expiration, mark as archived instead of forgotten.
  final bool archiveOnExpire;

  /// Minimum retention before archival/forget is allowed.
  final Duration? minRetention;

  /// Entries with priority below this may be evicted first.
  final int priorityFloor;

  static const defaults = AssistantMemoryPolicy(
    defaultTtl: Duration(days: 30),
    maxEntriesPerScope: 200,
    replaceSameKey: true,
    archiveOnExpire: true,
    minRetention: Duration(hours: 1),
    priorityFloor: 0,
  );

  Map<String, Object?> toDeterministicMap() => {
        'defaultTtlMs': defaultTtl?.inMilliseconds,
        'maxEntriesPerScope': maxEntriesPerScope,
        'replaceSameKey': replaceSameKey,
        'archiveOnExpire': archiveOnExpire,
        'minRetentionMs': minRetention?.inMilliseconds,
        'priorityFloor': priorityFloor,
      };
}

/// Evaluation outcome for policy checks.
class AssistantMemoryPolicyDecision {
  const AssistantMemoryPolicyDecision({
    required this.allowed,
    required this.action,
    this.reason,
  });

  final bool allowed;
  final AssistantMemoryPolicyAction action;
  final String? reason;

  Map<String, Object?> toDeterministicMap() => {
        'allowed': allowed,
        'action': action.name,
        'reason': reason,
      };
}

enum AssistantMemoryPolicyAction {
  keep,
  expire,
  archive,
  replace,
  evict,
  reject,
}

/// Evaluates expiration / retention / replacement against an entry.
class AssistantMemoryPolicyEvaluator {
  const AssistantMemoryPolicyEvaluator({
    this.policy = AssistantMemoryPolicy.defaults,
  });

  final AssistantMemoryPolicy policy;

  /// Whether the entry is past its expiration.
  AssistantMemoryPolicyDecision evaluateExpiration(
    AssistantMemoryEntry entry, {
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now().toUtc();
    final expiresAt = entry.metadata.expiresAt ??
        (policy.defaultTtl == null
            ? null
            : entry.createdAt.add(policy.defaultTtl!));

    if (expiresAt == null || !clock.isAfter(expiresAt)) {
      return const AssistantMemoryPolicyDecision(
        allowed: true,
        action: AssistantMemoryPolicyAction.keep,
      );
    }

    if (policy.minRetention != null) {
      final earliest = entry.createdAt.add(policy.minRetention!);
      if (clock.isBefore(earliest)) {
        return const AssistantMemoryPolicyDecision(
          allowed: true,
          action: AssistantMemoryPolicyAction.keep,
          reason: 'within_min_retention',
        );
      }
    }

    return AssistantMemoryPolicyDecision(
      allowed: true,
      action: policy.archiveOnExpire
          ? AssistantMemoryPolicyAction.archive
          : AssistantMemoryPolicyAction.expire,
      reason: 'expired',
    );
  }

  /// Whether a new remember should replace an existing same-key entry.
  AssistantMemoryPolicyDecision evaluateReplacement({
    required AssistantMemoryEntry? existing,
    required AssistantMemoryEntry incoming,
  }) {
    if (existing == null) {
      return const AssistantMemoryPolicyDecision(
        allowed: true,
        action: AssistantMemoryPolicyAction.keep,
      );
    }
    if (!policy.replaceSameKey) {
      return const AssistantMemoryPolicyDecision(
        allowed: false,
        action: AssistantMemoryPolicyAction.reject,
        reason: 'replace_disabled',
      );
    }
    final existingPriority = existing.metadata.priority;
    final incomingPriority = incoming.metadata.priority;
    if (incomingPriority < existingPriority &&
        incomingPriority < policy.priorityFloor) {
      return const AssistantMemoryPolicyDecision(
        allowed: false,
        action: AssistantMemoryPolicyAction.reject,
        reason: 'lower_priority',
      );
    }
    return const AssistantMemoryPolicyDecision(
      allowed: true,
      action: AssistantMemoryPolicyAction.replace,
      reason: 'same_key',
    );
  }

  /// Eviction candidate when scope exceeds [maxEntriesPerScope].
  AssistantMemoryPolicyDecision evaluateCapacity({
    required int currentCount,
  }) {
    if (currentCount < policy.maxEntriesPerScope) {
      return const AssistantMemoryPolicyDecision(
        allowed: true,
        action: AssistantMemoryPolicyAction.keep,
      );
    }
    return const AssistantMemoryPolicyDecision(
      allowed: true,
      action: AssistantMemoryPolicyAction.evict,
      reason: 'scope_capacity',
    );
  }
}
