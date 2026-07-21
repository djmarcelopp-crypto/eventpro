import 'assistant_memory_type.dart';

/// Well-known retrieval keys for last-used operational facts (AI-024 CP-5).
///
/// Contracts only — no NLP. Callers pass these keys to [AssistantPersistentMemory].
abstract final class AssistantMemoryKeys {
  static const lastClient = 'last.client';
  static const lastQuote = 'last.quote';
  static const lastEvent = 'last.event';
  static const lastSupplier = 'last.supplier';
  static const lastDecision = 'last.decision';
  static const lastWorkflow = 'last.workflow';
  static const lastCapability = 'last.capability';
  static const lastEntity = 'last.entity';
}

/// Suggested type + scope defaults for well-known keys.
class AssistantMemoryKeyProfile {
  const AssistantMemoryKeyProfile({
    required this.key,
    required this.type,
    required this.scope,
  });

  final String key;
  final AssistantMemoryType type;
  final AssistantMemoryScope scope;

  static const profiles = <AssistantMemoryKeyProfile>[
    AssistantMemoryKeyProfile(
      key: AssistantMemoryKeys.lastClient,
      type: AssistantMemoryType.entity,
      scope: AssistantMemoryScope.session,
    ),
    AssistantMemoryKeyProfile(
      key: AssistantMemoryKeys.lastQuote,
      type: AssistantMemoryType.business,
      scope: AssistantMemoryScope.session,
    ),
    AssistantMemoryKeyProfile(
      key: AssistantMemoryKeys.lastEvent,
      type: AssistantMemoryType.entity,
      scope: AssistantMemoryScope.session,
    ),
    AssistantMemoryKeyProfile(
      key: AssistantMemoryKeys.lastSupplier,
      type: AssistantMemoryType.entity,
      scope: AssistantMemoryScope.session,
    ),
    AssistantMemoryKeyProfile(
      key: AssistantMemoryKeys.lastDecision,
      type: AssistantMemoryType.reasoning,
      scope: AssistantMemoryScope.session,
    ),
    AssistantMemoryKeyProfile(
      key: AssistantMemoryKeys.lastWorkflow,
      type: AssistantMemoryType.workflow,
      scope: AssistantMemoryScope.session,
    ),
    AssistantMemoryKeyProfile(
      key: AssistantMemoryKeys.lastCapability,
      type: AssistantMemoryType.business,
      scope: AssistantMemoryScope.session,
    ),
    AssistantMemoryKeyProfile(
      key: AssistantMemoryKeys.lastEntity,
      type: AssistantMemoryType.entity,
      scope: AssistantMemoryScope.session,
    ),
  ];
}
