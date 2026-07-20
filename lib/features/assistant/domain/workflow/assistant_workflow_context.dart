/// Immutable bag of structured outputs shared across workflow steps.
class AssistantWorkflowContext {
  const AssistantWorkflowContext({
    this.values = const {},
  });

  final Map<String, Object?> values;

  Object? operator [](String key) => values[key];

  bool containsKey(String key) => values.containsKey(key);

  /// Returns a new context with [key] set (never mutates this instance).
  AssistantWorkflowContext put(String key, Object? value) {
    return AssistantWorkflowContext(
      values: Map<String, Object?>.unmodifiable({
        ...values,
        key: value,
      }),
    );
  }

  /// Merges [entries] into a new context.
  AssistantWorkflowContext putAll(Map<String, Object?> entries) {
    if (entries.isEmpty) return this;
    return AssistantWorkflowContext(
      values: Map<String, Object?>.unmodifiable({
        ...values,
        ...entries,
      }),
    );
  }

  Map<String, Object?> toDeterministicMap() => Map.unmodifiable(values);
}
