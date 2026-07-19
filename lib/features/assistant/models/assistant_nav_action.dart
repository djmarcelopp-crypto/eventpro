import 'assistant_action_kind.dart';
import 'assistant_action_target.dart';

/// AI-012 smart/navigation action unit.
///
/// Named [AssistantNavAction] to avoid colliding with AI-001 [AssistantAction]
/// (proposed UI buttons). This is the PLAY "AssistantAction" contract.
class AssistantNavAction {
  const AssistantNavAction({
    required this.id,
    required this.kind,
    required this.target,
    this.title,
    this.description,
  });

  final String id;
  final AssistantActionKind kind;
  final AssistantActionTarget target;
  final String? title;
  final String? description;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'kind': kind.name,
        'target': target.toDeterministicMap(),
        'title': title,
        'description': description,
      };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantNavAction &&
            other.id == id &&
            other.kind == kind &&
            other.target == target &&
            other.title == title &&
            other.description == description;
  }

  @override
  int get hashCode => Object.hash(id, kind, target, title, description);
}
