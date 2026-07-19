/// Declares which logical fields should appear in each read record.
///
/// Empty [fields] means adapter default summary projection.
class AssistantReadProjection {
  const AssistantReadProjection({this.fields = const []});

  final List<String> fields;

  bool get isDefault => fields.isEmpty;

  Map<String, Object?> toDeterministicMap() {
    final sorted = [...fields.map((f) => f.trim()).where((f) => f.isNotEmpty)]
      ..sort();
    return {'fields': sorted};
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantReadProjection && _listEquals(other.fields, fields);
  }

  @override
  int get hashCode => Object.hashAll(fields);

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
