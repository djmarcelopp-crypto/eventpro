import '../../models/assistant_write_observation.dart';

/// Non-authoritative observer for write pipeline metrics.
abstract class AssistantWriteObserver {
  void onObservation(AssistantWriteObservation observation);
}

/// No-op observer (default).
class NoOpAssistantWriteObserver implements AssistantWriteObserver {
  const NoOpAssistantWriteObserver();

  @override
  void onObservation(AssistantWriteObservation observation) {}
}

/// In-memory collector for tests and local diagnostics.
class InMemoryAssistantWriteObserver implements AssistantWriteObserver {
  final List<AssistantWriteObservation> observations = [];

  @override
  void onObservation(AssistantWriteObservation observation) {
    observations.add(observation);
  }
}

/// Observer that never throws into the write pipeline.
class SafeAssistantWriteObserver implements AssistantWriteObserver {
  SafeAssistantWriteObserver(this._inner);

  final AssistantWriteObserver _inner;

  @override
  void onObservation(AssistantWriteObservation observation) {
    try {
      _inner.onObservation(observation);
    } catch (_) {
      // Observability must never break business execution.
    }
  }
}
