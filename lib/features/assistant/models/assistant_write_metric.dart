import 'assistant_write_observation.dart';
import 'assistant_write_outcome_category.dart';

/// Named metric extracted from a write observation (non-authoritative).
class AssistantWriteMetric {
  const AssistantWriteMetric({
    required this.name,
    required this.outcome,
    required this.durationMs,
    required this.executed,
    required this.mutatedErp,
  });

  final String name;
  final AssistantWriteOutcomeCategory outcome;
  final int durationMs;
  final bool executed;
  final bool mutatedErp;

  factory AssistantWriteMetric.fromObservation(
    AssistantWriteObservation observation, {
    String name = 'assistant.write',
  }) {
    return AssistantWriteMetric(
      name: name,
      outcome: observation.outcome,
      durationMs: observation.durationMs < 0 ? 0 : observation.durationMs,
      executed: observation.executed,
      mutatedErp: observation.mutatedErp,
    );
  }

  Map<String, Object?> toMap() => {
        'name': name,
        'outcome': outcome.name,
        'durationMs': durationMs < 0 ? 0 : durationMs,
        'executed': executed,
        'mutatedErp': mutatedErp,
      };
}
