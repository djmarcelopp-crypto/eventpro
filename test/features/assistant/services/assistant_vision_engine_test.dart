import 'package:eventpro/features/assistant/domain/context/assistant_turn_identity.dart';
import 'package:eventpro/features/assistant/domain/vision/assistant_document_analysis.dart';
import 'package:eventpro/features/assistant/domain/vision/assistant_ocr.dart';
import 'package:eventpro/features/assistant/domain/vision/assistant_vision_core.dart';
import 'package:eventpro/features/assistant/domain/vision/assistant_vision_port.dart';
import 'package:eventpro/features/assistant/domain/vision/assistant_vision_result.dart';
import 'package:eventpro/features/assistant/domain/vision/assistant_vision_types.dart';
import 'package:eventpro/features/assistant/domain/vision/assistant_visual_analysis.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_vision_router.dart';
import 'package:eventpro/features/assistant/services/local_mock_vision_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-026 vision engine', () {
    final now = DateTime.utc(2026, 7, 20, 23);
    DateTime clock() => now;

    AssistantVisionRequest req(
      String fileName, {
      AssistantVisionPrivacyMetadata privacy =
          const AssistantVisionPrivacyMetadata(),
    }) {
      return AssistantVisionRequest(
        input: AssistantVisionInput(
          type: AssistantVisionInputType.document,
          reference: AssistantVisionReference(
            uri: 'ref:$fileName',
            fileName: fileName,
          ),
        ),
        metadata: const AssistantVisionMetadata(
          correlationId: 'corr-v',
          requestId: 'req-v',
        ),
        privacy: privacy,
      );
    }

    test('contracts: reference never carries bytes', () {
      const reference = AssistantVisionReference(
        uri: 'storage://docs/contrato.pdf',
        fileName: 'contrato.pdf',
        mimeType: 'application/pdf',
      );
      expect(reference.isValid, isTrue);
      expect(reference.toDeterministicMap().containsKey('bytes'), isFalse);
    });

    test('OCR domain stub is structured', () async {
      final engine = LocalMockVisionEngine(clock: clock);
      final ocr = await engine.extractText(
        const AssistantOcrRequest(
          referenceUri: 'ref:x',
          fileName: 'contrato.pdf',
          languageHint: 'pt',
        ),
      );
      expect(ocr.pages, hasLength(1));
      expect(ocr.pages.first.blocks, isNotEmpty);
      expect(ocr.pages.first.blocks.first.lines, isNotEmpty);
      expect(ocr.fullText, contains('mock-ocr:'));
      expect(ocr.characterCount, greaterThan(0));
    });

    test('document analysis maps contrato/orcamento/comprovante', () async {
      final engine = LocalMockVisionEngine(clock: clock);
      expect(
        (await engine.analyzeDocument(
          const AssistantDocumentAnalysisRequest(
            referenceUri: 'a',
            fileName: 'contrato-cliente.pdf',
          ),
        ))
            .documentType,
        AssistantDocumentType.contract,
      );
      expect(
        (await engine.analyzeDocument(
          const AssistantDocumentAnalysisRequest(
            referenceUri: 'b',
            fileName: 'orcamento-evento.pdf',
          ),
        ))
            .documentType,
        AssistantDocumentType.quote,
      );
      expect(
        (await engine.analyzeDocument(
          const AssistantDocumentAnalysisRequest(
            referenceUri: 'c',
            fileName: 'comprovante-pix.png',
          ),
        ))
            .documentType,
        AssistantDocumentType.receipt,
      );
    });

    test('visual entities for palco and energia', () async {
      final engine = LocalMockVisionEngine(clock: clock);
      final stage = await engine.detectEntities(req('foto-palco.jpg'));
      expect(
        stage.map((e) => e.type),
        containsAll([
          AssistantVisualEntityType.stage,
          AssistantVisualEntityType.speaker,
          AssistantVisualEntityType.truss,
        ]),
      );

      final power = await engine.detectEntities(req('quadro-energia.png'));
      expect(
        power.map((e) => e.type),
        contains(AssistantVisualEntityType.powerDistributor),
      );
    });

    test('mock analyze emits business signals only', () async {
      final observer = CollectingAssistantVisionObserver();
      final engine = LocalMockVisionEngine(clock: clock, observer: observer);
      final result = await engine.analyze(req('contrato-assinado.pdf'));

      expect(result.isSuccess, isTrue);
      expect(result.document.documentType, AssistantDocumentType.contract);
      expect(
        result.signals.map((s) => s.code),
        containsAll([
          'document_looks_like_contract',
          'signature_detected',
        ]),
      );
      expect(observer.records, isNotEmpty);
      expect(observer.records.first.correlationId, 'corr-v');
    });

    test('unknown input yields low confidence without inventing critical data',
        () async {
      final engine = LocalMockVisionEngine(clock: clock);
      final result = await engine.analyze(req('arquivo-xyz.bin'));
      expect(result.confidence, AssistantVisionConfidence.low);
      expect(result.document.documentType, AssistantDocumentType.unknown);
      expect(
        result.signals.map((s) => s.code),
        contains('unknown_low_confidence'),
      );
      expect(result.document.fields, isEmpty);
    });

    test('invalid reference returns standardized error', () async {
      final engine = LocalMockVisionEngine(clock: clock);
      final result = await engine.analyze(
        const AssistantVisionRequest(
          input: AssistantVisionInput(
            type: AssistantVisionInputType.unknown,
            reference: AssistantVisionReference(uri: '   '),
          ),
        ),
      );
      expect(result.isSuccess, isFalse);
      expect(result.error?.code, AssistantVisionErrorCode.invalidReference);
    });

    test('privacy restricted path', () async {
      final engine = LocalMockVisionEngine(clock: clock);
      final result = await engine.analyze(
        req(
          'contrato.pdf',
          privacy: const AssistantVisionPrivacyMetadata(
            sensitivity: AssistantVisionSensitivity.personalData,
            containsPersonalData: true,
            redacted: true,
          ),
        ),
      );
      expect(result.status, AssistantVisionResultStatus.restricted);
      expect(result.error?.code, AssistantVisionErrorCode.privacyRestricted);
    });

    test('router selects by capability and priority', () {
      final router = LocalAssistantVisionRouter();
      final low = LocalMockVisionEngine(engineId: 'vision.low', clock: clock);
      final high = LocalMockVisionEngine(engineId: 'vision.high', clock: clock);
      router.register(
        LocalMockVisionEngine.registration(port: low, priority: 1),
      );
      router.register(
        LocalMockVisionEngine.registration(port: high, priority: 20),
      );

      final selected = router.select(
        const AssistantVisionSelectionCriteria(
          requiredCapabilities: {AssistantVisionCapability.documentAnalysis},
        ),
      );
      expect(selected?.registration.engineId, 'vision.high');
      expect(selected?.reason, 'capability_priority');
    });

    test('flag OFF keeps default behavior', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localDefaults(),
      );
      final response = await orch.handle(
        AssistantRequest(
          id: 'req-off',
          rawText: 'contrato.pdf',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 's-off'),
        ),
      );
      expect(response.friendlyMessage, isNotEmpty);
      expect(orch.visionRouter.list(), isEmpty);
    });

    test('flag ON injects vision hints and preserves identity', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localVisionEngine(),
      );
      final request = AssistantRequest(
        id: 'req-on',
        rawText: 'contrato-final.pdf',
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: const AssistantContext(
          sessionId: 's-on',
          hints: ['fileName:contrato-final.pdf'],
        ),
      );

      final response = await orch.handle(request);
      expect(response.friendlyMessage, isNotEmpty);
      expect(response.requestId, 'req-on');
      expect(orch.visionRouter.list(), isNotEmpty);

      final identity = AssistantTurnIdentity.resolve(request);
      expect(identity.sessionId, 's-on');
      expect(identity.conversationId, 's-on');
    });

    test('capability factory enables vision engine', () {
      expect(
        AssistantCapabilities.localDefaults().canUseVisionEngine,
        isFalse,
      );
      expect(
        AssistantCapabilities.localVisionEngine().canUseVisionEngine,
        isTrue,
      );
    });

    test('error codes and sensitivity enums are complete', () {
      expect(AssistantVisionErrorCode.values, hasLength(8));
      expect(AssistantVisionSensitivity.values, hasLength(7));
      expect(AssistantVisualEntityType.values.length, greaterThanOrEqualTo(15));
      expect(AssistantDocumentType.values.length, greaterThanOrEqualTo(9));
    });
  });
}
