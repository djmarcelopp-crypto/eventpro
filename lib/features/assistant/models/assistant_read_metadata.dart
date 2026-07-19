import 'assistant_module_data_source.dart';
import 'assistant_read_filter.dart';
import 'assistant_read_pagination.dart';

/// Provenance and execution metadata for a structured read.
class AssistantReadMetadata {
  const AssistantReadMetadata({
    required this.timestamp,
    required this.source,
    required this.appliedFilters,
    required this.pagination,
    required this.executionTimeMs,
    this.totalMatched = 0,
    this.warnings = const [],
  });

  final DateTime timestamp;
  final AssistantModuleDataSource source;
  final List<AssistantReadFilter> appliedFilters;
  final AssistantReadPagination pagination;
  final int executionTimeMs;
  final int totalMatched;
  final List<String> warnings;

  Map<String, Object?> toDeterministicMap() {
    final filters = [...appliedFilters]
      ..sort((a, b) {
        final byField = a.field.compareTo(b.field);
        if (byField != 0) return byField;
        final byOp = a.operator.compareTo(b.operator);
        if (byOp != 0) return byOp;
        return a.value.compareTo(b.value);
      });
    final sortedWarnings = [...warnings]..sort();
    final duration = executionTimeMs < 0 ? 0 : executionTimeMs;
    return {
      'timestamp': timestamp.toUtc().toIso8601String(),
      'source': source.name,
      'appliedFilters': filters.map((f) => f.toDeterministicMap()).toList(),
      'pagination': pagination.toDeterministicMap(),
      'executionTimeMs': duration,
      'totalMatched': totalMatched < 0 ? 0 : totalMatched,
      'warnings': sortedWarnings,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantReadMetadata &&
            other.timestamp == timestamp &&
            other.source == source &&
            _filtersEqual(other.appliedFilters, appliedFilters) &&
            other.pagination == pagination &&
            other.executionTimeMs == executionTimeMs &&
            other.totalMatched == totalMatched &&
            _listEquals(other.warnings, warnings);
  }

  @override
  int get hashCode => Object.hash(
        timestamp,
        source,
        Object.hashAll(appliedFilters),
        pagination,
        executionTimeMs,
        totalMatched,
        Object.hashAll(warnings),
      );

  static bool _filtersEqual(
    List<AssistantReadFilter> a,
    List<AssistantReadFilter> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
