import 'assistant_execution_decision.dart';
import 'assistant_execution_status.dart';
import 'assistant_execution_step.dart';
import 'assistant_execution_warning.dart';

/// Explicit, auditable plan describing what the assistant would do.
///
/// AI-002 never executes steps — confirmation and execution are future work.
class AssistantExecutionPlan {
  const AssistantExecutionPlan({
    required this.id,
    required this.requestId,
    required this.steps,
    required this.overallStatus,
    this.decisions = const [],
    this.warnings = const [],
    this.summary = '',
  });

  final String id;
  final String requestId;
  final List<AssistantExecutionStep> steps;
  final AssistantExecutionStatus overallStatus;
  final List<AssistantExecutionDecision> decisions;
  final List<AssistantExecutionWarning> warnings;
  final String summary;

  List<AssistantExecutionStep> get blockedSteps =>
      steps.where((s) => s.isBlocked).toList(growable: false);

  List<AssistantExecutionStep> get unavailableSteps =>
      steps.where((s) => s.isUnavailable).toList(growable: false);

  List<AssistantExecutionStep> get readySteps =>
      steps.where((s) => s.isReady).toList(growable: false);

  List<AssistantExecutionStep> get stepsRequiringConfirmation =>
      steps.where((s) => s.requiresConfirmation).toList(growable: false);

  bool get hasBlockedSteps => blockedSteps.isNotEmpty;

  bool get hasUnavailableSteps => unavailableSteps.isNotEmpty;

  bool get hasExecutableReadySteps => readySteps.isNotEmpty;

  AssistantExecutionPlan copyWith({
    String? id,
    String? requestId,
    List<AssistantExecutionStep>? steps,
    AssistantExecutionStatus? overallStatus,
    List<AssistantExecutionDecision>? decisions,
    List<AssistantExecutionWarning>? warnings,
    String? summary,
  }) {
    return AssistantExecutionPlan(
      id: id ?? this.id,
      requestId: requestId ?? this.requestId,
      steps: steps ?? this.steps,
      overallStatus: overallStatus ?? this.overallStatus,
      decisions: decisions ?? this.decisions,
      warnings: warnings ?? this.warnings,
      summary: summary ?? this.summary,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionPlan &&
            other.id == id &&
            other.requestId == requestId &&
            _listEquals(other.steps, steps) &&
            other.overallStatus == overallStatus &&
            _listEquals(other.decisions, decisions) &&
            _listEquals(other.warnings, warnings) &&
            other.summary == summary;
  }

  @override
  int get hashCode => Object.hash(
        id,
        requestId,
        Object.hashAll(steps),
        overallStatus,
        Object.hashAll(decisions),
        Object.hashAll(warnings),
        summary,
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
