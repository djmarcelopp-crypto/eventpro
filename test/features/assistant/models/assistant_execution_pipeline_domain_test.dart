import 'package:eventpro/features/assistant/models/assistant_confirmation_status.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_audit.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_context.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_mode.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_outcome.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_policy.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_result.dart';
import 'package:eventpro/features/assistant/models/assistant_execution_token.dart';
import 'package:eventpro/features/assistant/models/assistant_integration_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-004 execution pipeline domain', () {
    test('modes policy and token are pure value objects', () {
      expect(
        AssistantExecutionMode.values,
        containsAll([
          AssistantExecutionMode.dryRun,
          AssistantExecutionMode.simulation,
          AssistantExecutionMode.production,
        ]),
      );
      const policy = AssistantExecutionPolicy.ai004Defaults;
      expect(policy.allowProduction, isFalse);
      expect(policy.allows(AssistantExecutionMode.dryRun), isTrue);
      expect(policy.allows(AssistantExecutionMode.production), isFalse);
      expect(const AssistantExecutionToken('tok-1').value, 'tok-1');
    });

    test('context and audit stay in-memory and immutable', () {
      final context = AssistantExecutionContext(
        requestId: 'req-1',
        token: const AssistantExecutionToken('tok-1'),
        mode: AssistantExecutionMode.dryRun,
        integrationMode: AssistantIntegrationMode.none,
        timestamp: DateTime(2026, 7, 19, 12),
      );
      final audit = AssistantExecutionAudit(
        timestamp: context.timestamp,
        executionToken: context.token,
        executionMode: context.mode,
        stepIds: const ['s1'],
        confirmationStatus: AssistantConfirmationStatus.notRequired,
        plannerVersion: context.plannerVersion,
        integrationMode: context.integrationMode,
      );
      expect(context.mode, AssistantExecutionMode.dryRun);
      expect(audit.executionToken, context.token);
      expect(
        const AssistantExecutionResult(
          stepId: 's1',
          outcome: AssistantExecutionOutcome.simulated,
          message: 'dry-run',
        ).outcome,
        AssistantExecutionOutcome.simulated,
      );
    });
  });
}
