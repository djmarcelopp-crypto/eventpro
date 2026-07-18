import 'assistant_entity_type.dart';

/// Clarifying question for missing/ambiguous information.
class AssistantQuestion {
  const AssistantQuestion({
    required this.id,
    required this.prompt,
    this.relatedEntityType,
    this.required = true,
  });

  final String id;
  final String prompt;
  final AssistantEntityType? relatedEntityType;
  final bool required;

  AssistantQuestion copyWith({
    String? id,
    String? prompt,
    AssistantEntityType? relatedEntityType,
    bool? required,
    bool clearRelatedEntityType = false,
  }) {
    return AssistantQuestion(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      relatedEntityType: clearRelatedEntityType
          ? null
          : (relatedEntityType ?? this.relatedEntityType),
      required: required ?? this.required,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantQuestion &&
            other.id == id &&
            other.prompt == prompt &&
            other.relatedEntityType == relatedEntityType &&
            other.required == required;
  }

  @override
  int get hashCode =>
      Object.hash(id, prompt, relatedEntityType, required);
}
