import 'assistant_read_filter.dart';
import 'assistant_read_pagination.dart';
import 'assistant_read_projection.dart';
import 'assistant_read_sort.dart';

/// Complete structured read request — module-agnostic query object.
///
/// Adapters decide how filters map to ERP APIs (no findByX helpers here).
class AssistantReadQuery {
  const AssistantReadQuery({
    required this.id,
    required this.requestId,
    required this.module,
    this.filters = const [],
    this.projection = const AssistantReadProjection(),
    this.sorting = const [],
    this.pagination = const AssistantReadPagination(),
    this.requiredCapabilities = const {},
  });

  final String id;
  final String requestId;

  /// Logical module key (e.g. `quote`). Never a concrete ERP type.
  final String module;

  final List<AssistantReadFilter> filters;
  final AssistantReadProjection projection;
  final List<AssistantReadSort> sorting;
  final AssistantReadPagination pagination;

  /// Capability names the caller declares as required for execution.
  final Set<String> requiredCapabilities;

  Map<String, Object?> toDeterministicMap() {
    final sortedFilters = [...filters]
      ..sort((a, b) {
        final byField = a.field.compareTo(b.field);
        if (byField != 0) return byField;
        return a.value.compareTo(b.value);
      });
    final sortedCaps = [...requiredCapabilities]..sort();
    return {
      'id': id,
      'requestId': requestId,
      'module': module,
      'filters': sortedFilters.map((f) => f.toDeterministicMap()).toList(),
      'projection': projection.toDeterministicMap(),
      'sorting': sorting.map((s) => s.toDeterministicMap()).toList(),
      'pagination': pagination.toDeterministicMap(),
      'requiredCapabilities': sortedCaps,
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantReadQuery &&
            other.id == id &&
            other.requestId == requestId &&
            other.module == module &&
            _filtersEqual(other.filters, filters) &&
            other.projection == projection &&
            _sortsEqual(other.sorting, sorting) &&
            other.pagination == pagination &&
            _setEquals(other.requiredCapabilities, requiredCapabilities);
  }

  @override
  int get hashCode => Object.hash(
        id,
        requestId,
        module,
        Object.hashAll(filters),
        projection,
        Object.hashAll(sorting),
        pagination,
        Object.hashAll(requiredCapabilities),
      );

  static bool _filtersEqual(
    List<AssistantReadFilter> a,
    List<AssistantReadFilter> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _sortsEqual(List<AssistantReadSort> a, List<AssistantReadSort> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static bool _setEquals(Set<String> a, Set<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}

/// Well-known module keys for structured reads (expansion points).
abstract final class AssistantReadModules {
  static const quote = 'quote';
}

/// Capability name required to execute structured quote reads.
abstract final class AssistantReadCapabilities {
  static const structuredQuoteRead = 'structuredQuoteRead';
}
