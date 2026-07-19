/// Short textual summary of an insight result.
class AssistantInsightSummary {
  const AssistantInsightSummary({
    required this.text,
    this.highlights = const [],
  });

  final String text;
  final List<String> highlights;

  Map<String, Object?> toDeterministicMap() => {
        'text': text,
        'highlights': highlights,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantInsightSummary &&
            other.text == text &&
            _same(other.highlights, highlights);
  }

  @override
  int get hashCode => Object.hash(text, Object.hashAll(highlights));

  static bool _same(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
