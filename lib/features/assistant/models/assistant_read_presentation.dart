/// Natural-language + structured payload for a read result (future UI).
class AssistantReadPresentation {
  const AssistantReadPresentation({
    required this.naturalLanguage,
    required this.structured,
  });

  final String naturalLanguage;
  final Map<String, Object?> structured;

  Map<String, Object?> toDeterministicMap() {
    final keys = structured.keys.toList()..sort();
    return {
      'naturalLanguage': naturalLanguage,
      'structured': {for (final k in keys) k: structured[k]},
    };
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantReadPresentation &&
            other.naturalLanguage == naturalLanguage &&
            _mapEquals(other.structured, structured);
  }

  @override
  int get hashCode =>
      Object.hash(naturalLanguage, Object.hashAll(structured.entries));

  static bool _mapEquals(Map<String, Object?> a, Map<String, Object?> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (final e in a.entries) {
      if (b[e.key] != e.value) return false;
    }
    return true;
  }
}
