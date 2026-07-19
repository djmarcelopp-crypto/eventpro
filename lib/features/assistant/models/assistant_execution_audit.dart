import 'assistant_confirmation_status.dart';
import 'assistant_execution_decision.dart';
import 'assistant_execution_mode.dart';
import 'assistant_execution_token.dart';
import 'assistant_integration_mode.dart';
import 'assistant_module_data_source.dart';

/// In-memory audit trail for one controlled execution attempt.
///
/// Never persisted to disk or SQLite in AI-004.
class AssistantExecutionAudit {
  const AssistantExecutionAudit({
    required this.timestamp,
    required this.executionToken,
    required this.executionMode,
    required this.stepIds,
    required this.confirmationStatus,
    required this.plannerVersion,
    required this.integrationMode,
    this.dataSources = const [],
    this.decisions = const [],
  });

  final DateTime timestamp;
  final AssistantExecutionToken executionToken;
  final AssistantExecutionMode executionMode;
  final List<String> stepIds;

  /// Aggregate confirmation status label for the attempt.
  final AssistantConfirmationStatus confirmationStatus;

  final String plannerVersion;
  final AssistantIntegrationMode integrationMode;
  final List<AssistantModuleDataSource> dataSources;

  /// Reuses planner audit decision records for explainability.
  final List<AssistantExecutionDecision> decisions;

  AssistantExecutionAudit copyWith({
    DateTime? timestamp,
    AssistantExecutionToken? executionToken,
    AssistantExecutionMode? executionMode,
    List<String>? stepIds,
    AssistantConfirmationStatus? confirmationStatus,
    String? plannerVersion,
    AssistantIntegrationMode? integrationMode,
    List<AssistantModuleDataSource>? dataSources,
    List<AssistantExecutionDecision>? decisions,
  }) {
    return AssistantExecutionAudit(
      timestamp: timestamp ?? this.timestamp,
      executionToken: executionToken ?? this.executionToken,
      executionMode: executionMode ?? this.executionMode,
      stepIds: stepIds ?? this.stepIds,
      confirmationStatus: confirmationStatus ?? this.confirmationStatus,
      plannerVersion: plannerVersion ?? this.plannerVersion,
      integrationMode: integrationMode ?? this.integrationMode,
      dataSources: dataSources ?? this.dataSources,
      decisions: decisions ?? this.decisions,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionAudit &&
            other.timestamp == timestamp &&
            other.executionToken == executionToken &&
            other.executionMode == executionMode &&
            _listEquals(other.stepIds, stepIds) &&
            other.confirmationStatus == confirmationStatus &&
            other.plannerVersion == plannerVersion &&
            other.integrationMode == integrationMode &&
            _listEquals(other.dataSources, dataSources) &&
            _listEquals(other.decisions, decisions);
  }

  @override
  int get hashCode => Object.hash(
        timestamp,
        executionToken,
        executionMode,
        Object.hashAll(stepIds),
        confirmationStatus,
        plannerVersion,
        integrationMode,
        Object.hashAll(dataSources),
        Object.hashAll(decisions),
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
