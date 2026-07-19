import 'assistant_execution_mode.dart';
import 'assistant_execution_policy.dart';
import 'assistant_execution_token.dart';
import 'assistant_integration_mode.dart';

/// Immutable context for one controlled execution attempt.
class AssistantExecutionContext {
  const AssistantExecutionContext({
    required this.requestId,
    required this.token,
    required this.mode,
    required this.integrationMode,
    required this.timestamp,
    this.confirmedStepIds = const {},
    this.plannerVersion = 'AI-002',
    this.policy = AssistantExecutionPolicy.ai004Defaults,
  });

  final String requestId;
  final AssistantExecutionToken token;
  final AssistantExecutionMode mode;
  final AssistantIntegrationMode integrationMode;
  final DateTime timestamp;
  final Set<String> confirmedStepIds;
  final String plannerVersion;
  final AssistantExecutionPolicy policy;

  AssistantExecutionContext copyWith({
    String? requestId,
    AssistantExecutionToken? token,
    AssistantExecutionMode? mode,
    AssistantIntegrationMode? integrationMode,
    DateTime? timestamp,
    Set<String>? confirmedStepIds,
    String? plannerVersion,
    AssistantExecutionPolicy? policy,
  }) {
    return AssistantExecutionContext(
      requestId: requestId ?? this.requestId,
      token: token ?? this.token,
      mode: mode ?? this.mode,
      integrationMode: integrationMode ?? this.integrationMode,
      timestamp: timestamp ?? this.timestamp,
      confirmedStepIds: confirmedStepIds ?? this.confirmedStepIds,
      plannerVersion: plannerVersion ?? this.plannerVersion,
      policy: policy ?? this.policy,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantExecutionContext &&
            other.requestId == requestId &&
            other.token == token &&
            other.mode == mode &&
            other.integrationMode == integrationMode &&
            other.timestamp == timestamp &&
            _setEquals(other.confirmedStepIds, confirmedStepIds) &&
            other.plannerVersion == plannerVersion &&
            other.policy == policy;
  }

  @override
  int get hashCode => Object.hash(
        requestId,
        token,
        mode,
        integrationMode,
        timestamp,
        Object.hashAll(confirmedStepIds),
        plannerVersion,
        policy,
      );

  static bool _setEquals(Set<String> a, Set<String> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}
