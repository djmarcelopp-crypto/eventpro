import 'assistant_action_type.dart';

/// A proposed action. Never executed by AI-001 services.
class AssistantAction {
  const AssistantAction({
    required this.type,
    required this.available,
    this.label = '',
    this.blockedReason,
  });

  final AssistantActionType type;
  final bool available;
  final String label;
  final String? blockedReason;

  AssistantAction copyWith({
    AssistantActionType? type,
    bool? available,
    String? label,
    String? blockedReason,
    bool clearBlockedReason = false,
  }) {
    return AssistantAction(
      type: type ?? this.type,
      available: available ?? this.available,
      label: label ?? this.label,
      blockedReason: clearBlockedReason
          ? null
          : (blockedReason ?? this.blockedReason),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantAction &&
            other.type == type &&
            other.available == available &&
            other.label == label &&
            other.blockedReason == blockedReason;
  }

  @override
  int get hashCode => Object.hash(type, available, label, blockedReason);
}
