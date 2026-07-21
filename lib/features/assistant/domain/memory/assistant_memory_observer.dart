import 'assistant_memory_result.dart';

/// Observability sink for memory operations (AI-024 CP-8).
///
/// Contracts only — no concrete logging, telemetry, or HTTP.
abstract class AssistantMemoryObserver {
  void record(AssistantMemoryOperationRecord record);
}

/// Default no-op observer.
class NoopAssistantMemoryObserver implements AssistantMemoryObserver {
  const NoopAssistantMemoryObserver();

  @override
  void record(AssistantMemoryOperationRecord record) {}
}

/// In-process collector for tests / local debugging (still no I/O).
class CollectingAssistantMemoryObserver implements AssistantMemoryObserver {
  CollectingAssistantMemoryObserver();

  final List<AssistantMemoryOperationRecord> records = [];

  @override
  void record(AssistantMemoryOperationRecord record) {
    records.add(record);
  }
}
