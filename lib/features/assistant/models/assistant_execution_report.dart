import 'assistant_execution_audit.dart';
import 'assistant_execution_mode.dart';
import 'assistant_execution_result.dart';
import 'assistant_execution_step.dart';

/// Typed dry-run/simulation report produced by the execution dispatcher.
class AssistantExecutionReport {
  const AssistantExecutionReport({
    required this.mode,
    required this.audit,
    required this.summary,
    this.eligibleSteps = const [],
    this.blockedSteps = const [],
    this.unavailableSteps = const [],
    this.awaitingConfirmationSteps = const [],
    this.simulatedSteps = const [],
    this.skippedSteps = const [],
    this.results = const [],
    this.warnings = const [],
  });

  final AssistantExecutionMode mode;
  final AssistantExecutionAudit audit;
  final String summary;
  final List<AssistantExecutionStep> eligibleSteps;
  final List<AssistantExecutionStep> blockedSteps;
  final List<AssistantExecutionStep> unavailableSteps;
  final List<AssistantExecutionStep> awaitingConfirmationSteps;
  final List<AssistantExecutionStep> simulatedSteps;
  final List<AssistantExecutionStep> skippedSteps;
  final List<AssistantExecutionResult> results;
  final List<String> warnings;

  bool get mutatedErp => false;

  AssistantExecutionReport copyWith({
    AssistantExecutionMode? mode,
    AssistantExecutionAudit? audit,
    String? summary,
    List<AssistantExecutionStep>? eligibleSteps,
    List<AssistantExecutionStep>? blockedSteps,
    List<AssistantExecutionStep>? unavailableSteps,
    List<AssistantExecutionStep>? awaitingConfirmationSteps,
    List<AssistantExecutionStep>? simulatedSteps,
    List<AssistantExecutionStep>? skippedSteps,
    List<AssistantExecutionResult>? results,
    List<String>? warnings,
  }) {
    return AssistantExecutionReport(
      mode: mode ?? this.mode,
      audit: audit ?? this.audit,
      summary: summary ?? this.summary,
      eligibleSteps: eligibleSteps ?? this.eligibleSteps,
      blockedSteps: blockedSteps ?? this.blockedSteps,
      unavailableSteps: unavailableSteps ?? this.unavailableSteps,
      awaitingConfirmationSteps:
          awaitingConfirmationSteps ?? this.awaitingConfirmationSteps,
      simulatedSteps: simulatedSteps ?? this.simulatedSteps,
      skippedSteps: skippedSteps ?? this.skippedSteps,
      results: results ?? this.results,
      warnings: warnings ?? this.warnings,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionReport &&
            other.mode == mode &&
            other.audit == audit &&
            other.summary == summary &&
            _listEquals(other.eligibleSteps, eligibleSteps) &&
            _listEquals(other.blockedSteps, blockedSteps) &&
            _listEquals(other.unavailableSteps, unavailableSteps) &&
            _listEquals(
              other.awaitingConfirmationSteps,
              awaitingConfirmationSteps,
            ) &&
            _listEquals(other.simulatedSteps, simulatedSteps) &&
            _listEquals(other.skippedSteps, skippedSteps) &&
            _listEquals(other.results, results) &&
            _listEquals(other.warnings, warnings);
  }

  @override
  int get hashCode => Object.hash(
        mode,
        audit,
        summary,
        Object.hashAll(eligibleSteps),
        Object.hashAll(blockedSteps),
        Object.hashAll(unavailableSteps),
        Object.hashAll(awaitingConfirmationSteps),
        Object.hashAll(simulatedSteps),
        Object.hashAll(skippedSteps),
        Object.hashAll(results),
        Object.hashAll(warnings),
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
