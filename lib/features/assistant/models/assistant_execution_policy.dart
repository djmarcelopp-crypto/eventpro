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
    this.allowRestrictedQuoteDraftProduction = false,
  });

  final List<AssistantExecutionMode> allowedModes;
  final bool requireConfirmationForWrites;

  /// Broad production unlock — still false by default (AI-004).
  final bool allowProduction;

  /// AI-006 narrow exception: production only for create quote draft.
  final bool allowRestrictedQuoteDraftProduction;

  static const ai004Defaults = AssistantExecutionPolicy();

  /// Policy for AI-006 quote-draft production writes (still confirmation-gated).
  static const ai006QuoteDraftProduction = AssistantExecutionPolicy(
    allowedModes: [
      AssistantExecutionMode.dryRun,
      AssistantExecutionMode.simulation,
      AssistantExecutionMode.production,
    ],
    requireConfirmationForWrites: true,
    allowProduction: true,
    allowRestrictedQuoteDraftProduction: true,
  );

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
    bool? allowRestrictedQuoteDraftProduction,
  }) {
    return AssistantExecutionPolicy(
      allowedModes: allowedModes ?? this.allowedModes,
      requireConfirmationForWrites:
          requireConfirmationForWrites ?? this.requireConfirmationForWrites,
      allowProduction: allowProduction ?? this.allowProduction,
      allowRestrictedQuoteDraftProduction:
          allowRestrictedQuoteDraftProduction ??
              this.allowRestrictedQuoteDraftProduction,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionPolicy &&
            _listEquals(other.allowedModes, allowedModes) &&
            other.requireConfirmationForWrites ==
                requireConfirmationForWrites &&
            other.allowProduction == allowProduction &&
            other.allowRestrictedQuoteDraftProduction ==
                allowRestrictedQuoteDraftProduction;
  }

  @override
  int get hashCode => Object.hash(
        Object.hashAll(allowedModes),
        requireConfirmationForWrites,
        allowProduction,
        allowRestrictedQuoteDraftProduction,
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
