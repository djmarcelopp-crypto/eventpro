import 'assistant_entity_type.dart';
import 'assistant_parse_issue_type.dart';

/// Explainable problem found while interpreting the request.
class AssistantParseIssue {
  const AssistantParseIssue({
    required this.type,
    required this.message,
    this.entityType,
    this.details = const [],
  });

  final AssistantParseIssueType type;
  final String message;
  final AssistantEntityType? entityType;
  final List<String> details;

  AssistantParseIssue copyWith({
    AssistantParseIssueType? type,
    String? message,
    AssistantEntityType? entityType,
    List<String>? details,
    bool clearEntityType = false,
  }) {
    return AssistantParseIssue(
      type: type ?? this.type,
      message: message ?? this.message,
      entityType: clearEntityType ? null : (entityType ?? this.entityType),
      details: details ?? this.details,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantParseIssue &&
            other.type == type &&
            other.message == message &&
            other.entityType == entityType &&
            _listEquals(other.details, details);
  }

  @override
  int get hashCode =>
      Object.hash(type, message, entityType, Object.hashAll(details));

  static bool _listEquals(List<String> a, List<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
