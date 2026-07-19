import 'assistant_module_capability.dart';

/// Read-only request sent to a module gateway/adapter.
class AssistantModuleRequest {
  const AssistantModuleRequest({
    required this.id,
    required this.requestId,
    required this.capability,
    this.query,
    this.parameters = const {},
  });

  final String id;
  final String requestId;
  final AssistantModuleCapability capability;
  final String? query;
  final Map<String, String> parameters;

  AssistantModuleRequest copyWith({
    String? id,
    String? requestId,
    AssistantModuleCapability? capability,
    String? query,
    Map<String, String>? parameters,
    bool clearQuery = false,
  }) {
    return AssistantModuleRequest(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      capability: capability ?? this.capability,
      query: clearQuery ? null : (query ?? this.query),
      parameters: parameters ?? this.parameters,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantModuleRequest &&
            other.id == id &&
            other.requestId == requestId &&
            other.capability == capability &&
            other.query == query &&
            _mapEquals(other.parameters, parameters);
  }

  @override
  int get hashCode => Object.hash(
        id,
        requestId,
        capability,
        query,
        Object.hashAll(parameters.entries),
      );

  static bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
