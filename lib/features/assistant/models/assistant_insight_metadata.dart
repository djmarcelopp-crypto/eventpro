import 'assistant_module_data_source.dart';

/// Execution metadata for an insight computation.
class AssistantInsightMetadata {
  const AssistantInsightMetadata({
    required this.timestamp,
    required this.source,
    required this.scannedCount,
    required this.maxScan,
    required this.scanCapped,
    this.executionTimeMs = 0,
    this.module = '',
    this.kind = '',
  });

  final DateTime timestamp;
  final AssistantModuleDataSource source;
  final int scannedCount;
  final int maxScan;
  final bool scanCapped;
  final int executionTimeMs;
  final String module;
  final String kind;

  Map<String, Object?> toDeterministicMap() => {
        'timestamp': timestamp.toUtc().toIso8601String(),
        'source': source.name,
        'scannedCount': scannedCount,
        'maxScan': maxScan,
        'scanCapped': scanCapped,
        'executionTimeMs': executionTimeMs,
        'module': module,
        'kind': kind,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantInsightMetadata &&
            other.timestamp == timestamp &&
            other.source == source &&
            other.scannedCount == scannedCount &&
            other.maxScan == maxScan &&
            other.scanCapped == scanCapped &&
            other.executionTimeMs == executionTimeMs &&
            other.module == module &&
            other.kind == kind;
  }

  @override
  int get hashCode => Object.hash(
        timestamp,
        source,
        scannedCount,
        maxScan,
        scanCapped,
        executionTimeMs,
        module,
        kind,
      );
}
