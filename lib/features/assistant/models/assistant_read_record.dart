/// Module-agnostic row returned by a structured read.
class AssistantReadRecord {
  const AssistantReadRecord({
    required this.id,
    this.displayName = '',
    this.attributes = const {},
  });

  final String id;
  final String displayName;
  final Map<String, String> attributes;

  Map<String, Object?> toDeterministicMap() {
    final keys = attributes.keys.toList()..sort();
    return {
      'id': id,
      'displayName': displayName,
      'attributes': {for (final k in keys) k: attributes[k]},
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantReadRecord &&
            other.id == id &&
            other.displayName == displayName &&
            _mapEquals(other.attributes, attributes);
  }

  @override
  int get hashCode => Object.hash(id, displayName, Object.hashAll(attributes.entries));

  static bool _mapEquals(Map<String, String> a, Map<String, String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }
}
