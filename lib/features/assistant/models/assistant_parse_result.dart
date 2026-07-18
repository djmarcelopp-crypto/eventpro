import 'assistant_entity.dart';
import 'assistant_parse_issue.dart';

/// Intermediate parser output before intent classification.
class AssistantParseResult {
  const AssistantParseResult({
    required this.entities,
    this.issues = const [],
    this.normalizedText = '',
  });

  final List<AssistantEntity> entities;
  final List<AssistantParseIssue> issues;
  final String normalizedText;

  AssistantParseResult copyWith({
    List<AssistantEntity>? entities,
    List<AssistantParseIssue>? issues,
    String? normalizedText,
  }) {
    return AssistantParseResult(
      entities: entities ?? this.entities,
      issues: issues ?? this.issues,
      normalizedText: normalizedText ?? this.normalizedText,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantParseResult &&
            _listEquals(other.entities, entities) &&
            _listEquals(other.issues, issues) &&
            other.normalizedText == normalizedText;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(entities),
        Object.hashAll(issues),
        normalizedText,
      );

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
