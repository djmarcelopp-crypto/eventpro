import 'assistant_confirmation_policy.dart';
import 'assistant_execution_requirement.dart';
import 'assistant_execution_risk.dart';
import 'assistant_execution_status.dart';
import 'assistant_module_target.dart';

/// One ordered step in an [AssistantExecutionPlan].
///
/// Describes what would happen — never executes ERP operations.
class AssistantExecutionStep {
  const AssistantExecutionStep({
    required this.id,
    required this.order,
    required this.moduleTarget,
    required this.intendedAction,
    required this.description,
    required this.status,
    this.preconditions = const [],
    this.dependencyStepIds = const [],
    this.risks = const [],
    this.confirmationPolicy = AssistantConfirmationPolicy.none,
    this.blockReason,
  });

  final String id;
  final int order;
  final AssistantModuleTarget moduleTarget;

  /// Stable action key (e.g. `createEvent`, `createQuote`).
  final String intendedAction;
  final String description;
  final AssistantExecutionStatus status;
  final List<AssistantExecutionRequirement> preconditions;

  /// IDs of steps that must precede this one.
  final List<String> dependencyStepIds;
  final List<AssistantExecutionRisk> risks;
  final AssistantConfirmationPolicy confirmationPolicy;
  final String? blockReason;

  bool get requiresConfirmation =>
      confirmationPolicy != AssistantConfirmationPolicy.none;

  bool get isBlocked => status == AssistantExecutionStatus.blocked;

  bool get isUnavailable => status == AssistantExecutionStatus.unavailable;

  bool get isReady => status == AssistantExecutionStatus.ready;

  bool get isAwaitingConfirmation =>
      status == AssistantExecutionStatus.awaitingConfirmation;

  AssistantExecutionStep copyWith({
    String? id,
    int? order,
    AssistantModuleTarget? moduleTarget,
    String? intendedAction,
    String? description,
    AssistantExecutionStatus? status,
    List<AssistantExecutionRequirement>? preconditions,
    List<String>? dependencyStepIds,
    List<AssistantExecutionRisk>? risks,
    AssistantConfirmationPolicy? confirmationPolicy,
    String? blockReason,
    bool clearBlockReason = false,
  }) {
    return AssistantExecutionStep(
      id: id ?? this.id,
      order: order ?? this.order,
      moduleTarget: moduleTarget ?? this.moduleTarget,
      intendedAction: intendedAction ?? this.intendedAction,
      description: description ?? this.description,
      status: status ?? this.status,
      preconditions: preconditions ?? this.preconditions,
      dependencyStepIds: dependencyStepIds ?? this.dependencyStepIds,
      risks: risks ?? this.risks,
      confirmationPolicy: confirmationPolicy ?? this.confirmationPolicy,
      blockReason:
          clearBlockReason ? null : (blockReason ?? this.blockReason),
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionStep &&
            other.id == id &&
            other.order == order &&
            other.moduleTarget == moduleTarget &&
            other.intendedAction == intendedAction &&
            other.description == description &&
            other.status == status &&
            _listEquals(other.preconditions, preconditions) &&
            _listEquals(other.dependencyStepIds, dependencyStepIds) &&
            _listEquals(other.risks, risks) &&
            other.confirmationPolicy == confirmationPolicy &&
            other.blockReason == blockReason;
  }

  @override
  int get hashCode => Object.hash(
        id,
        order,
        moduleTarget,
        intendedAction,
        description,
        status,
        Object.hashAll(preconditions),
        Object.hashAll(dependencyStepIds),
        Object.hashAll(risks),
        confirmationPolicy,
        blockReason,
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
