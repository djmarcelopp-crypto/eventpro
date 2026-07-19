import 'assistant_execution_mode.dart';

/// Hard rules for the controlled execution pipeline.
class AssistantExecutionPolicy {
  const AssistantExecutionPolicy({
    this.allowedModes = const [
      AssistantExecutionMode.dryRun,
      AssistantExecutionMode.simulation,
    ],
    this.requireConfirmationForWrites = true,
    this.allowProduction = false,
  });

  final List<AssistantExecutionMode> allowedModes;
  final bool requireConfirmationForWrites;

  /// Always false in AI-004.
  final bool allowProduction;

  static const ai004Defaults = AssistantExecutionPolicy();

  bool allows(AssistantExecutionMode mode) {
    if (mode == AssistantExecutionMode.production && !allowProduction) {
      return false;
    }
    return allowedModes.contains(mode);
  }

  AssistantExecutionPolicy copyWith({
    List<AssistantExecutionMode>? allowedModes,
    bool? requireConfirmationForWrites,
    bool? allowProduction,
  }) {
    return AssistantExecutionPolicy(
      allowedModes: allowedModes ?? this.allowedModes,
      requireConfirmationForWrites:
          requireConfirmationForWrites ?? this.requireConfirmationForWrites,
      allowProduction: allowProduction ?? this.allowProduction,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionPolicy &&
            _listEquals(other.allowedModes, allowedModes) &&
            other.requireConfirmationForWrites ==
                requireConfirmationForWrites &&
            other.allowProduction == allowProduction;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(allowedModes),
        requireConfirmationForWrites,
        allowProduction,
      );

  static bool _listEquals(
    List<AssistantExecutionMode> a,
    List<AssistantExecutionMode> b,
  ) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
