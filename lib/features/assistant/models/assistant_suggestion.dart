import 'assistant_provenance.dart';

/// Soft guidance for the user (never an ERP mutation).
class AssistantSuggestion {
  const AssistantSuggestion({
    required this.message,
    required this.provenance,
    this.id,
  });

  final String? id;
  final String message;
  final AssistantProvenance provenance;

  AssistantSuggestion copyWith({
    String? id,
    String? message,
    AssistantProvenance? provenance,
    bool clearId = false,
  }) {
    return AssistantSuggestion(
      id: clearId ? null : (id ?? this.id),
      message: message ?? this.message,
      provenance: provenance ?? this.provenance,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantSuggestion &&
            other.id == id &&
            other.message == message &&
            other.provenance == provenance;
  }

  @override
  int get hashCode => Object.hash(id, message, provenance);
}
