import 'package:eventpro/features/assistant/domain/business/assistant_business_operation.dart';
import 'package:eventpro/features/assistant/domain/business/assistant_business_reference.dart';
import 'package:eventpro/features/assistant/domain/business/capabilities/assistant_business_capability.dart';
import 'package:eventpro/features/assistant/domain/business/capabilities/assistant_business_capability_category.dart';
import 'package:eventpro/features/assistant/domain/business/capabilities/assistant_business_capability_constraint.dart';
import 'package:eventpro/features/assistant/domain/business/capabilities/assistant_business_capability_id.dart';
import 'package:eventpro/features/assistant/domain/business/capabilities/assistant_business_capability_input.dart';
import 'package:eventpro/features/assistant/domain/business/capabilities/assistant_business_capability_metadata.dart';
import 'package:eventpro/features/assistant/domain/business/capabilities/assistant_business_capability_version.dart';
import 'package:eventpro/features/assistant/domain/business/capabilities/assistant_business_capability_warning.dart';
import 'package:eventpro/features/assistant/domain/business/capabilities/capability_resolution_status.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_business_context.dart';
import 'package:eventpro/features/assistant/domain/workflow/assistant_workflow_context.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/models/assistant_workflow_intent.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_business_capability_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_business_capability_resolver.dart';
import 'package:eventpro/features/assistant/services/local_assistant_business_gateway.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_workflow_planner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-018 business capability engine', () {
    final now = DateTime.utc(2026, 7, 20, 18);
    DateTime clock() => now;

    AssistantRequest req(String text, {String id = 'req-cap'}) {
      return AssistantRequest(
        id: id,
        rawText: text,
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: const AssistantContext(sessionId: 's-cap'),
      );
    }

    test('capability registry: catálogo extensível sem switch', () {
      final registry = LocalAssistantBusinessCapabilityRegistry.defaults();
      expect(registry.capabilities, hasLength(6));
      expect(
        registry.contains(AssistantBusinessCapabilityIds.findClient),
        isTrue,
      );
      expect(
        registry
            .findByOperationCode(AssistantBusinessOperationCodes.createQuote)
            ?.id,
        AssistantBusinessCapabilityIds.createQuote,
      );
      expect(
        registry.find(AssistantBusinessCapabilityIds.findClient)?.version,
        AssistantBusinessCapabilityVersion.v1,
      );
      expect(
        registry.find(AssistantBusinessCapabilityIds.createQuote)?.category,
        AssistantBusinessCapabilityCategory.create,
      );
      expect(
        registry
            .findByCategory(AssistantBusinessCapabilityCategory.lookup)
            .length,
        4,
      );

      final extended = registry.register(
        const AssistantBusinessCapability(
          id: AssistantBusinessCapabilityId('CustomCap'),
          version: AssistantBusinessCapabilityVersion(major: 2, minor: 1),
          category: AssistantBusinessCapabilityCategory.mutate,
          metadata: AssistantBusinessCapabilityMetadata(
            label: 'Custom',
            operationCode: 'CUSTOM',
          ),
        ),
      );
      expect(extended.contains(const AssistantBusinessCapabilityId('CustomCap')),
          isTrue);
      expect(
        extended.find(const AssistantBusinessCapabilityId('CustomCap'))?.version
            .label,
        '2.1.0',
      );
    });

    test('resolver: valida inputs obrigatórios', () {
      final registry = LocalAssistantBusinessCapabilityRegistry.defaults()
          .register(
        const AssistantBusinessCapability(
          id: AssistantBusinessCapabilityId('NeedsQuery'),
          metadata: AssistantBusinessCapabilityMetadata(label: 'Needs query'),
          inputs: [
            AssistantBusinessCapabilityInput(key: 'query', required: true),
          ],
        ),
      );
      final resolver =
          LocalAssistantBusinessCapabilityResolver(registry: registry);

      final missing = resolver.resolve(
        id: const AssistantBusinessCapabilityId('NeedsQuery'),
      );
      expect(missing.ready, isFalse);
      expect(missing.status, CapabilityResolutionStatus.missingInput);
      expect(
        missing.warnings.map((w) => w.code),
        contains(AssistantBusinessCapabilityWarning.missingInput),
      );

      final ok = resolver.resolve(
        id: const AssistantBusinessCapabilityId('NeedsQuery'),
        inputs: const {'query': 'abc'},
      );
      expect(ok.ready, isTrue);
      expect(ok.status, CapabilityResolutionStatus.ready);
    });

    test('resolver: restrições e sequência FindClient → CreateQuote', () {
      final resolver = LocalAssistantBusinessCapabilityResolver();

      final alone = resolver.resolve(
        id: AssistantBusinessCapabilityIds.createQuote,
      );
      expect(alone.ready, isFalse);
      expect(alone.status, CapabilityResolutionStatus.unmetConstraint);
      expect(
        alone.warnings.map((w) => w.code),
        contains(AssistantBusinessCapabilityWarning.unmetConstraint),
      );

      final unknown = resolver.resolve(
        id: const AssistantBusinessCapabilityId('MissingCap'),
      );
      expect(unknown.status, CapabilityResolutionStatus.notFound);

      final sequence = resolver.resolveSequence(
        ids: const [
          AssistantBusinessCapabilityIds.findClient,
          AssistantBusinessCapabilityIds.createQuote,
        ],
      );
      expect(sequence, hasLength(2));
      expect(sequence.every((r) => r.ready), isTrue);
      expect(
        sequence.every((r) => r.status == CapabilityResolutionStatus.ready),
        isTrue,
      );
      expect(sequence.first.capability?.outputs.first.key,
          AssistantWorkflowBusinessKeys.clientReference);
    });

    test('resolver: requiresPriorCapability', () {
      final registry = LocalAssistantBusinessCapabilityRegistry.defaults()
          .register(
        const AssistantBusinessCapability(
          id: AssistantBusinessCapabilityId('AfterFind'),
          metadata: AssistantBusinessCapabilityMetadata(label: 'After'),
          constraints: [
            AssistantBusinessCapabilityConstraint(
              kind: AssistantBusinessCapabilityConstraintKind
                  .requiresPriorCapability,
              key: 'FindClient',
            ),
          ],
        ),
      );
      final resolver =
          LocalAssistantBusinessCapabilityResolver(registry: registry);

      final bad = resolver.resolveSequence(
        ids: const [AssistantBusinessCapabilityId('AfterFind')],
      );
      expect(bad.single.ready, isFalse);

      final good = resolver.resolveSequence(
        ids: const [
          AssistantBusinessCapabilityIds.findClient,
          AssistantBusinessCapabilityId('AfterFind'),
        ],
      );
      expect(good.every((r) => r.ready), isTrue);
    });

    test('planner: business recipe resolve capabilities; sem gateway', () {
      final planner = LocalAssistantWorkflowPlanner(clock: clock);
      final plan = planner.planExecution(
        const RunWorkflowIntent(
          AssistantWorkflowRecipe.findClientThenCreateQuote,
        ),
        requestId: 'p1',
        request: req('x'),
      );
      expect(plan, isNotNull);
      expect(plan!.resolvedCapabilities, hasLength(2));
      expect(plan.resolvedCapabilities.every((r) => r.ready), isTrue);
      expect(plan.executionNodes, hasLength(2));
      expect(plan.capabilitiesReady, isTrue);
      expect(plan.executionNodes.first.category,
          AssistantBusinessCapabilityCategory.lookup);
      expect(plan.executionNodes.last.category,
          AssistantBusinessCapabilityCategory.create);
      expect(
        plan.executionNodes.every(
          (n) => n.version == AssistantBusinessCapabilityVersion.v1,
        ),
        isTrue,
      );
      expect(
        plan.executionNodes.every(
          (n) => n.status == CapabilityResolutionStatus.ready,
        ),
        isTrue,
      );
      expect(plan.executionNodes.first.stepId, isNotNull);
      expect(plan.definitionId, 'findClientThenCreateQuote');
    });

    test('planner: AI-016 recipe sem capabilities no plano', () {
      final planner = LocalAssistantWorkflowPlanner(clock: clock);
      final plan = planner.planExecution(
        const RunWorkflowIntent(
          AssistantWorkflowRecipe.confirmationCreateThenAudit,
        ),
        requestId: 'p2',
        request: req('x'),
      );
      expect(plan, isNotNull);
      expect(plan!.resolvedCapabilities, isEmpty);
      expect(plan.executionNodes, isEmpty);
      expect(plan.capabilitiesReady, isTrue);
    });

    test('contexto: capabilities, entities, deps, outputs', () {
      final resolutions =
          LocalAssistantBusinessCapabilityResolver().resolveSequence(
        ids: const [AssistantBusinessCapabilityIds.findClient],
      );
      const client = ClientReference(id: 'c1');
      final ctx = const AssistantWorkflowContext()
          .withResolvedCapabilities(resolutions)
          .withProducedEntities([client])
          .withSatisfiedDependencies(
            {AssistantWorkflowBusinessKeys.clientReference},
          )
          .withSharedOutputs({'note': 'ok'});

      expect(ctx.resolvedCapabilities, hasLength(1));
      expect(ctx.producedEntities.single.id, 'c1');
      expect(
        ctx.satisfiedDependencies,
        contains(AssistantWorkflowBusinessKeys.clientReference),
      );
      expect(ctx.sharedOutputs['note'], 'ok');
    });

    test('isolamento: capability model sem ERP', () {
      final cap = LocalAssistantBusinessCapabilityRegistry.defaults()
          .find(AssistantBusinessCapabilityIds.findClient)!;
      expect(cap, isA<AssistantBusinessCapability>());
      expect(cap.metadata.operationCode, AssistantBusinessOperationCodes.findClient);
      expect(cap.version.label, '1.0.0');
      expect(cap.category, AssistantBusinessCapabilityCategory.lookup);
      expect(cap.toDeterministicMap()['id'], isNotNull);
      expect(cap.toDeterministicMap()['version'], isNotNull);
      expect(cap.toDeterministicMap()['category'], 'lookup');
    });

    test('regressão AI-017: orchestrator business + legacy', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localBusinessWorkflow(),
        businessGateway: LocalAssistantBusinessGateway(),
      );

      final biz = await orch.handle(
        req('Buscar cliente e criar orçamento', id: 'orch-cap-biz'),
      );
      expect(biz.workflowResult?.completed, isTrue);
      expect(biz.workflowResult?.context.clientReference, isNotNull);
      expect(biz.workflowResult?.context.quoteReference, isNotNull);

      final legacy = await orch.handle(
        req(
          'Solicitar confirmação e mostrar auditoria',
          id: 'orch-cap-legacy',
        ),
      );
      expect(legacy.workflowResult?.completed, isTrue);
    });
  });
}
