import 'package:eventpro/features/assistant/domain/input/assistant_input.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_attachment.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_content.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_id.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_metadata.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_normalization_status.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_processing_request.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_processing_result.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_processing_status.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_processor.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_processor_id.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_source.dart';
import 'package:eventpro/features/assistant/domain/input/assistant_input_type.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/assistant_input_factory.dart';
import 'package:eventpro/features/assistant/services/local_assistant_input_normalizer.dart';
import 'package:eventpro/features/assistant/services/local_assistant_input_pipeline.dart';
import 'package:eventpro/features/assistant/services/local_assistant_input_processor_registry.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 7, 20, 22);

  AssistantInput textInput(String text, {String id = 't1'}) => AssistantInput(
        id: AssistantInputId(id),
        type: AssistantInputType.text,
        content: AssistantInputContent(text: text),
        metadata: const AssistantInputMetadata(
          source: AssistantInputSource.typedText,
          correlationId: 'c-text',
        ),
        receivedAt: now,
        correlationId: 'c-text',
      );

  AssistantInput media({
    required AssistantInputType type,
    required String mime,
    String ref = 'mem://x',
    int? durationMs,
    String id = 'm1',
  }) =>
      AssistantInput(
        id: AssistantInputId(id),
        type: type,
        content: AssistantInputContent(
          attachment: AssistantInputAttachment(
            reference: ref,
            mimeType: mime,
            fileName: 'file',
            sizeBytes: 10,
            durationMs: durationMs,
          ),
        ),
        metadata: AssistantInputMetadata(
          source: AssistantInputSource.filePicker,
          correlationId: 'c-$id',
        ),
        receivedAt: now,
        correlationId: 'c-$id',
      );

  group('AI-020 CP-2 normalizer', () {
    const normalizer = LocalAssistantInputNormalizer();

    test('texto válido normaliza espaços', () {
      final r = normalizer.normalize(textInput('  olá   mundo  \n\n\n'));
      expect(r.status, AssistantInputNormalizationStatus.ready);
      expect(r.normalizedText, 'olá mundo');
    });

    test('texto inválido', () {
      final r = normalizer.normalize(textInput('   '));
      expect(r.status, AssistantInputNormalizationStatus.invalid);
    });

    test('imagem válida → requiresProcessing', () {
      final r = normalizer.normalize(
        media(type: AssistantInputType.image, mime: 'image/png'),
      );
      expect(r.status, AssistantInputNormalizationStatus.requiresProcessing);
      expect(r.normalizedText, isNull);
    });

    test('áudio válido → requiresProcessing', () {
      final r = normalizer.normalize(
        media(
          type: AssistantInputType.audio,
          mime: 'audio/mpeg',
          durationMs: 1200,
        ),
      );
      expect(r.status, AssistantInputNormalizationStatus.requiresProcessing);
    });

    test('documento válido → requiresProcessing', () {
      final r = normalizer.normalize(
        media(type: AssistantInputType.document, mime: 'application/pdf'),
      );
      expect(r.status, AssistantInputNormalizationStatus.requiresProcessing);
    });

    test('mime não suportado', () {
      final r = normalizer.normalize(
        media(type: AssistantInputType.image, mime: 'application/octet-stream'),
      );
      expect(r.status, AssistantInputNormalizationStatus.unsupported);
    });

    test('attachment ausente', () {
      final r = normalizer.normalize(
        AssistantInput(
          id: const AssistantInputId('bad'),
          type: AssistantInputType.image,
          content: const AssistantInputContent(),
          metadata: const AssistantInputMetadata(
            source: AssistantInputSource.camera,
          ),
          receivedAt: now,
        ),
      );
      expect(r.status, AssistantInputNormalizationStatus.invalid);
    });
  });

  group('AI-020 CP-3 processor registry', () {
    test('defaults tem text; ausência segura para image', () {
      final registry = LocalAssistantInputProcessorRegistry.defaults();
      expect(registry.findByType(AssistantInputType.text), isNotNull);
      expect(registry.findByType(AssistantInputType.image), isNull);
      expect(registry.findByMimeType('text/plain'), isNotNull);
    });

    test('register imutável', () {
      final empty = LocalAssistantInputProcessorRegistry.empty();
      expect(empty.processors, isEmpty);
      final extended = empty.register(const _FailingProcessor());
      expect(extended.contains(const AssistantInputProcessorId('fail')), isTrue);
      expect(empty.processors, isEmpty);
    });
  });

  group('AI-020 CP-4 pipeline', () {
    test('texto válido', () async {
      final pipeline = LocalAssistantInputPipeline();
      final r = await pipeline.run(textInput('Buscar cliente Ana'));
      expect(r.readyForInterpretation, isTrue);
      expect(r.normalizedText, 'Buscar cliente Ana');
      expect(r.inputId, 't1');
      expect(r.correlationId, 'c-text');
    });

    test('texto inválido', () async {
      final r = await LocalAssistantInputPipeline().run(textInput('  '));
      expect(r.readyForInterpretation, isFalse);
      expect(r.normalization.status, AssistantInputNormalizationStatus.invalid);
    });

    test('imagem sem processor', () async {
      final r = await LocalAssistantInputPipeline(
        processorRegistry: LocalAssistantInputProcessorRegistry.empty(),
      ).run(media(type: AssistantInputType.image, mime: 'image/jpeg'));
      expect(r.readyForInterpretation, isFalse);
      expect(
        r.normalization.status,
        AssistantInputNormalizationStatus.requiresProcessing,
      );
      expect(r.processing?.status, AssistantInputProcessingStatus.unavailable);
    });

    test('áudio sem processor', () async {
      final r = await LocalAssistantInputPipeline(
        processorRegistry: LocalAssistantInputProcessorRegistry.empty(),
      ).run(
        media(type: AssistantInputType.audio, mime: 'audio/wav', durationMs: 1),
      );
      expect(
        r.normalization.status,
        AssistantInputNormalizationStatus.requiresProcessing,
      );
    });

    test('documento sem processor', () async {
      final r = await LocalAssistantInputPipeline(
        processorRegistry: LocalAssistantInputProcessorRegistry.empty(),
      ).run(media(type: AssistantInputType.document, mime: 'application/pdf'));
      expect(
        r.normalization.status,
        AssistantInputNormalizationStatus.requiresProcessing,
      );
    });

    test('mime não suportado', () async {
      final r = await LocalAssistantInputPipeline(
        processorRegistry: LocalAssistantInputProcessorRegistry.empty(),
      ).run(media(type: AssistantInputType.image, mime: 'application/octet-stream'));
      expect(
        r.normalization.status,
        AssistantInputNormalizationStatus.unsupported,
      );
      expect(r.readyForInterpretation, isFalse);
    });

    test('processor de texto registrado (defaults)', () async {
      final r = await LocalAssistantInputPipeline().run(
        textInput('Listar eventos', id: 'proc-ok'),
      );
      expect(r.processing?.status, AssistantInputProcessingStatus.completed);
      expect(r.readyForInterpretation, isTrue);
      expect(r.normalizedText, 'Listar eventos');
    });

    test('processor registrado falha controlada', () async {
      final registry = LocalAssistantInputProcessorRegistry.empty()
          .register(const _FailingProcessor());
      final r = await LocalAssistantInputPipeline(processorRegistry: registry)
          .run(textInput('x', id: 'fail-me'));
      expect(r.normalization.status, AssistantInputNormalizationStatus.failed);
      expect(r.inputId, 'fail-me');
    });

    test('preserva inputId e correlationId', () async {
      final input = textInput('ok', id: 'trace-9');
      final r = await LocalAssistantInputPipeline().run(input);
      expect(r.inputId, 'trace-9');
      expect(r.correlationId, 'c-text');
      expect(r.normalization.correlationId, 'c-text');
    });
  });

  group('AI-020 CP-5 integração', () {
    test('fluxo textual com multimodal opt-in', () async {
      final orch = LocalAssistantOrchestrator(
        clock: () => now,
        capabilities: AssistantCapabilities.localMultimodalInput(),
      );
      final response = await orch.handle(
        AssistantRequest(
          id: 'req-mm',
          rawText: '  criar   orçamento  ',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 's1'),
        ),
      );
      // Multimodal normalizes whitespace before interpretation.
      expect(response.rawText, 'criar orçamento');
      expect(response.friendlyMessage.toLowerCase(), contains('orçamento'));
    });

    test('factory fromRequest', () {
      final input = AssistantInputFactory.fromRequest(
        AssistantRequest(
          id: 'r1',
          rawText: 'hello',
          locale: 'pt_BR',
          timezone: 'UTC',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
        ),
      );
      expect(input.type, AssistantInputType.text);
      expect(input.content.text, 'hello');
      expect(input.effectiveCorrelationId, 'r1');
    });
  });
}

class _FailingProcessor implements AssistantInputProcessor {
  const _FailingProcessor();

  @override
  AssistantInputProcessorId get id =>
      const AssistantInputProcessorId('fail');

  @override
  Set<AssistantInputType> get supportedTypes => const {AssistantInputType.text};

  @override
  Set<String> get supportedMimeTypes => const {};

  @override
  Future<AssistantInputProcessingResult> process(
    AssistantInputProcessingRequest request,
  ) async {
    return AssistantInputProcessingResult(
      inputId: request.input.id.value,
      correlationId: request.input.effectiveCorrelationId,
      status: AssistantInputProcessingStatus.failed,
      processorId: id,
      message: 'controlled failure',
    );
  }
}
