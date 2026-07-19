import 'assistant_write_capability.dart';

/// Explicit authorization snapshot for a write intent.
///
/// Granting authorization never executes ERP writes in AI-005.
class AssistantWriteAuthorization {
  const AssistantWriteAuthorization({
    required this.granted,
    this.reason = '',
    this.allowedCapabilities = const {},
    this.requiresUserConfirmation = true,
  });

  final bool granted;
  final String reason;
  final Set<AssistantWriteCapability> allowedCapabilities;
  final bool requiresUserConfirmation;

  AssistantWriteAuthorization copyWith({
    bool? granted,
    String? reason,
    Set<AssistantWriteCapability>? allowedCapabilities,
    bool? requiresUserConfirmation,
  }) {
    return AssistantWriteAuthorization(
      granted: granted ?? this.granted,
      reason: reason ?? this.reason,
      allowedCapabilities: allowedCapabilities ?? this.allowedCapabilities,
      requiresUserConfirmation:
          requiresUserConfirmation ?? this.requiresUserConfirmation,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteAuthorization &&
            other.granted == granted &&
            other.reason == reason &&
            _setEquals(other.allowedCapabilities, allowedCapabilities) &&
            other.requiresUserConfirmation == requiresUserConfirmation;
  }

  @override
  int get hashCode => Object.hash(
        granted,
        reason,
        Object.hashAll(allowedCapabilities),
        requiresUserConfirmation,
      );

  static bool _setEquals(
    Set<AssistantWriteCapability> a,
    Set<AssistantWriteCapability> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}
