import 'package:eventpro/features/assistant/models/assistant_action_kind.dart';
import 'package:eventpro/features/assistant/models/assistant_confirmation_outcome.dart';
import 'package:eventpro/features/assistant/models/assistant_confirmation_warning.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_safe_confirmation_intent.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/assistant_confirmation_session_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_action_adapter.dart';
import 'package:eventpro/features/assistant/services/local_assistant_action_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_confirmation_formatter.dart';
import 'package:eventpro/features/assistant/services/local_assistant_confirmation_planner.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_safe_confirmation_intent_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-013 safe confirmation engine', () {
    var now = DateTime.utc(2026, 7, 19, 22);
    DateTime clock() => now;

    const caps = AssistantCapabilities(
      canPlanSafeConfirmation: true,
      canExecuteSafeConfirmation: true,
    );
    const resolver = LocalAssistantSafeConfirmationIntentResolver();
    const formatter = LocalAssistantConfirmationFormatter();

    AssistantRequest req(
      String text, {
      String id = 'req-ai13',
      String? sessionId,
    }) {
      return AssistantRequest(
        id: id,
        rawText: text,
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: sessionId == null
            ? null
            : AssistantContext(sessionId: sessionId),
      );
    }

    test('planner: criação, confirmação, cancelamento, inexistente, expiração',
        () {
      final registry = AssistantConfirmationSessionRegistry(clock: clock);
      final planner = LocalAssistantConfirmationPlanner(
        clock: clock,
        ttl: const Duration(minutes: 5),
        tokenFactory: () => 'fixed-token',
      );
      final session = registry.getOrCreate('s1');

      final createReq = planner.planRequest(
        const CreateConfirmationIntent(),
        requestId: 'c1',
        sessionId: 's1',
      );
      final created = planner.process(request: createReq, session: session);
      expect(created.outcome, AssistantConfirmationOutcome.previewCreated);
      expect(created.pending?.token.value, 'fixed-token');
      expect(created.preview, contains('Draft'));

      final confirmReq = planner.planRequest(
        const ConfirmPendingIntent(),
        requestId: 'c2',
        sessionId: 's1',
      );
      final confirmed = planner.process(request: confirmReq, session: session);
      expect(confirmed.outcome, AssistantConfirmationOutcome.confirmed);
      expect(confirmed.summary, contains('Nenhuma escrita'));

      // After confirm, new confirm → missing/invalid
      final again = planner.process(request: confirmReq, session: session);
      expect(
        again.outcome,
        anyOf(
          AssistantConfirmationOutcome.missing,
          AssistantConfirmationOutcome.invalid,
        ),
      );

      // Fresh pending then cancel
      planner.process(
        request: planner.planRequest(
          const CreateConfirmationIntent(),
          requestId: 'c3',
          sessionId: 's1',
        ),
        session: session,
      );
      final cancelled = planner.process(
        request: planner.planRequest(
          const CancelPendingIntent(),
          requestId: 'c4',
          sessionId: 's1',
        ),
        session: session,
      );
      expect(cancelled.outcome, AssistantConfirmationOutcome.cancelled);

      // Missing
      final missing = planner.process(
        request: planner.planRequest(
          const ConfirmPendingIntent(),
          requestId: 'c5',
          sessionId: 's1',
        ),
        session: session,
      );
      expect(missing.outcome, AssistantConfirmationOutcome.missing);
      expect(
        missing.warnings.any(
          (w) => w.code == AssistantConfirmationWarning.missingPending,
        ),
        isTrue,
      );

      // Expiry
      planner.process(
        request: planner.planRequest(
          const CreateConfirmationIntent(),
          requestId: 'c6',
          sessionId: 's1',
        ),
        session: session,
      );
      now = now.add(const Duration(minutes: 6));
      final expired = planner.process(
        request: planner.planRequest(
          const ConfirmPendingIntent(),
          requestId: 'c7',
          sessionId: 's1',
        ),
        session: session,
      );
      expect(expired.outcome, AssistantConfirmationOutcome.expired);

      // Reset
      now = DateTime.utc(2026, 7, 19, 22);
      planner.process(
        request: planner.planRequest(
          const CreateConfirmationIntent(),
          requestId: 'c8',
          sessionId: 's1',
        ),
        session: session,
      );
      expect(session.pending, isNotNull);
      session.reset();
      expect(session.pending, isNull);
    });

    test('múltiplas sessões isoladas + formatter', () {
      final registry = AssistantConfirmationSessionRegistry(clock: clock);
      final planner = LocalAssistantConfirmationPlanner(clock: clock);
      final a = registry.getOrCreate('a');
      final b = registry.getOrCreate('b');

      planner.process(
        request: planner.planRequest(
          const CreateConfirmationIntent(),
          requestId: 'a1',
          sessionId: 'a',
        ),
        session: a,
      );
      expect(a.pending, isNotNull);
      expect(b.pending, isNull);
      expect(registry.sessionCount, 2);

      final presentation = formatter.format(
        planner.process(
          request: planner.planRequest(
            const StatusPendingIntent(),
            requestId: 'a2',
            sessionId: 'a',
          ),
          session: a,
        ),
      );
      expect(presentation.naturalLanguage, contains('pendente'));
      expect(presentation.structured['outcome'], isNotNull);
    });

    test('intent resolver + ausência de sessão', () {
      expect(
        resolver.resolve(
          request: req('Solicitar confirmação para criar orçamento'),
          capabilities: caps,
        ),
        isA<CreateConfirmationIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Confirmar'),
          capabilities: caps,
        ),
        isA<ConfirmPendingIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Cancelar confirmação'),
          capabilities: caps,
        ),
        isA<CancelPendingIntent>(),
      );
      expect(
        resolver.resolve(
          request: req('Abra orçamentos'),
          capabilities: caps,
        ),
        isNull,
      );

      final planner = LocalAssistantConfirmationPlanner(clock: clock);
      final noSession = planner.process(
        request: planner.planRequest(
          const CreateConfirmationIntent(),
          requestId: 'x',
        ),
        session: null,
      );
      expect(noSession.outcome, AssistantConfirmationOutcome.invalid);
      expect(
        noSession.warnings.any(
          (w) => w.code == AssistantConfirmationWarning.missingSession,
        ),
        isTrue,
      );
    });

    test('pipeline E2E + compatibilidade AI-012', () async {
      now = DateTime.utc(2026, 7, 19, 22);
      final confirmationSessions =
          AssistantConfirmationSessionRegistry(clock: clock);
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localSafeConfirmation(),
        confirmationSessions: confirmationSessions,
        confirmationPlanner: LocalAssistantConfirmationPlanner(clock: clock),
        actionGateway: LocalAssistantActionGateway(
          adapter: LocalAssistantActionAdapter(clock: clock),
          clock: clock,
        ),
      );

      const sid = 'conf-e2e';
      final created = await orch.handle(
        req(
          'Solicitar confirmação para criar orçamento',
          id: 't1',
          sessionId: sid,
        ),
      );
      expect(created.confirmationResult, isNotNull);
      expect(
        created.confirmationResult!.outcome,
        AssistantConfirmationOutcome.previewCreated,
      );
      expect(created.actionResult, isNull);
      expect(created.writeResult?.executed ?? false, isFalse);
      expect(created.friendlyMessage, contains('Confirmação criada'));

      final confirmed = await orch.handle(
        req('Confirmar', id: 't2', sessionId: sid),
      );
      expect(
        confirmed.confirmationResult!.outcome,
        AssistantConfirmationOutcome.confirmed,
      );
      expect(confirmed.confirmationPresentation!.naturalLanguage,
          contains('Nenhuma escrita'));

      // AI-012 action still works when not a confirmation phrase.
      final action = await orch.handle(
        req('Abra a tela de Orçamentos.', id: 't3', sessionId: sid),
      );
      expect(action.confirmationResult, isNull);
      expect(action.actionResult, isNotNull);
      expect(action.actionResult!.actions.single.kind,
          AssistantActionKind.openQuotes);
    });
  });
}
