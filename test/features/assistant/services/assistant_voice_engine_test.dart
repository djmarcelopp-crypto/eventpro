import 'package:eventpro/features/assistant/domain/context/assistant_turn_identity.dart';
import 'package:eventpro/features/assistant/domain/voice/assistant_audio_core.dart';
import 'package:eventpro/features/assistant/domain/voice/assistant_audio_result.dart';
import 'package:eventpro/features/assistant/domain/voice/assistant_audio_types.dart';
import 'package:eventpro/features/assistant/domain/voice/assistant_speech.dart';
import 'package:eventpro/features/assistant/domain/voice/assistant_transcription.dart';
import 'package:eventpro/features/assistant/domain/voice/assistant_voice_port.dart';
import 'package:eventpro/features/assistant/models/assistant_context.dart';
import 'package:eventpro/features/assistant/models/assistant_input_origin.dart';
import 'package:eventpro/features/assistant/models/assistant_request.dart';
import 'package:eventpro/features/assistant/services/assistant_capabilities.dart';
import 'package:eventpro/features/assistant/services/local_assistant_orchestrator.dart';
import 'package:eventpro/features/assistant/services/local_assistant_voice_router.dart';
import 'package:eventpro/features/assistant/services/local_mock_voice_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AI-027 voice engine', () {
    final now = DateTime.utc(2026, 7, 20, 23, 30);
    DateTime clock() => now;

    AssistantAudioRequest req(
      String fileName, {
      AssistantAudioPrivacyMetadata privacy =
          const AssistantAudioPrivacyMetadata(),
    }) {
      return AssistantAudioRequest(
        input: AssistantAudioInput(
          type: AssistantAudioType.voiceNote,
          reference: AssistantAudioReference(
            uri: 'audio-ref:$fileName',
            fileName: fileName,
            mimeType: 'audio/mpeg',
          ),
        ),
        metadata: const AssistantAudioMetadata(
          correlationId: 'corr-a',
          requestId: 'req-a',
        ),
        privacy: privacy,
      );
    }

    test('contracts: reference never carries bytes', () {
      const reference = AssistantAudioReference(
        uri: 'storage://audio/cliente.mp3',
        fileName: 'cliente.mp3',
        mimeType: 'audio/mpeg',
        durationMs: 12000,
        sampleRateHz: 16000,
        channels: 1,
        encoding: 'mp3',
      );
      expect(reference.isValid, isTrue);
      expect(reference.toDeterministicMap().containsKey('bytes'), isFalse);
    });

    test('transcription has segments with timing speaker confidence', () async {
      final engine = LocalMockVoiceEngine(clock: clock);
      final result = await engine.transcribe(
        const AssistantTranscriptionRequest(
          referenceUri: 'a',
          fileName: 'cliente-ligacao.mp3',
          languageHint: 'pt',
        ),
      );
      expect(result.fullText, contains('cliente'));
      expect(result.segments, hasLength(1));
      expect(result.segments.first.speakerId, isNotNull);
      expect(result.segments.first.startMs, 0);
      expect(result.segments.first.endMs, greaterThan(0));
      expect(result.speakers, isNotEmpty);
    });

    test('detectSpeakers returns multiple for meeting', () async {
      final engine = LocalMockVoiceEngine(clock: clock);
      final speakers = await engine.detectSpeakers(req('reuniao-equipe.wav'));
      expect(speakers.length, greaterThanOrEqualTo(2));
    });

    test('mock analyze emits business signals only', () async {
      final observer = CollectingAssistantAudioObserver();
      final engine = LocalMockVoiceEngine(clock: clock, observer: observer);
      final result = await engine.analyzeAudio(req('pagamento-cliente.mp3'));
      expect(result.isSuccess, isTrue);
      expect(
        result.signals.map((s) => s.code),
        containsAll(['client_mentioned', 'payment_mentioned']),
      );
      expect(observer.records.first.correlationId, 'corr-a');
    });

    test('keyword rules for evento contrato palco', () async {
      final engine = LocalMockVoiceEngine(clock: clock);
      expect(
        (await engine.analyzeAudio(req('briefing-evento.mp3')))
            .signals
            .map((s) => s.code),
        contains('event_mentioned'),
      );
      expect(
        (await engine.analyzeAudio(req('revisao-contrato.mp3')))
            .signals
            .map((s) => s.code),
        contains('contract_mentioned'),
      );
      expect(
        (await engine.analyzeAudio(req('check-palco.mp3')))
            .signals
            .map((s) => s.code),
        contains('equipment_mentioned'),
      );
    });

    test('unknown yields low confidence', () async {
      final engine = LocalMockVoiceEngine(clock: clock);
      final result = await engine.analyzeAudio(req('arquivo-xyz.mp3'));
      expect(result.confidence, AssistantAudioConfidence.low);
      expect(
        result.signals.map((s) => s.code),
        contains('unknown_low_confidence'),
      );
    });

    test('synthesize returns reference without bytes', () async {
      final engine = LocalMockVoiceEngine(clock: clock);
      final speech = await engine.synthesize(
        const AssistantSpeechRequest(text: 'Olá', voiceProfileId: 'pt-br'),
      );
      expect(speech.success, isTrue);
      expect(speech.audioReferenceUri, startsWith('mock-tts://'));
      expect(speech.toDeterministicMap().containsKey('bytes'), isFalse);
    });

    test('invalid reference and privacy restricted errors', () async {
      final engine = LocalMockVoiceEngine(clock: clock);
      final invalid = await engine.analyzeAudio(
        const AssistantAudioRequest(
          input: AssistantAudioInput(
            type: AssistantAudioType.unknown,
            reference: AssistantAudioReference(uri: '  '),
          ),
        ),
      );
      expect(invalid.error?.code, AssistantAudioErrorCode.invalidReference);

      final restricted = await engine.analyzeAudio(
        req(
          'cliente.mp3',
          privacy: const AssistantAudioPrivacyMetadata(
            sensitivity: AssistantAudioSensitivity.personalData,
            containsPersonalData: true,
            redacted: true,
          ),
        ),
      );
      expect(
        restricted.error?.code,
        AssistantAudioErrorCode.privacyRestricted,
      );
    });

    test('router selects by capability and priority', () {
      final router = LocalAssistantVoiceRouter();
      router.register(
        LocalMockVoiceEngine.registration(
          port: LocalMockVoiceEngine(engineId: 'voice.low', clock: clock),
          priority: 1,
        ),
      );
      router.register(
        LocalMockVoiceEngine.registration(
          port: LocalMockVoiceEngine(engineId: 'voice.high', clock: clock),
          priority: 20,
        ),
      );
      final selected = router.select(
        const AssistantVoiceSelectionCriteria(
          requiredCapabilities: {AssistantAudioCapability.transcription},
        ),
      );
      expect(selected?.registration.engineId, 'voice.high');
    });

    test('flag OFF keeps default behavior', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localDefaults(),
      );
      final response = await orch.handle(
        AssistantRequest(
          id: 'req-off',
          rawText: 'cliente.mp3',
          locale: 'pt_BR',
          timezone: 'America/Sao_Paulo',
          timestamp: now,
          origin: AssistantInputOrigin.typedText,
          context: const AssistantContext(sessionId: 's-off'),
        ),
      );
      expect(response.friendlyMessage, isNotEmpty);
      expect(orch.voiceRouter.list(), isEmpty);
    });

    test('flag ON injects voice hints and preserves identity', () async {
      final orch = LocalAssistantOrchestrator(
        clock: clock,
        capabilities: AssistantCapabilities.localVoiceEngine(),
      );
      final request = AssistantRequest(
        id: 'req-on',
        rawText: 'ouvir gravacao',
        locale: 'pt_BR',
        timezone: 'America/Sao_Paulo',
        timestamp: now,
        origin: AssistantInputOrigin.typedText,
        context: const AssistantContext(
          sessionId: 's-on',
          hints: ['audioFileName:gravacao-cliente.mp3'],
        ),
      );
      final response = await orch.handle(request);
      expect(response.friendlyMessage, isNotEmpty);
      expect(response.requestId, 'req-on');
      expect(orch.voiceRouter.list(), isNotEmpty);

      final identity = AssistantTurnIdentity.resolve(request);
      expect(identity.sessionId, 's-on');
      expect(identity.conversationId, 's-on');
    });

    test('capability factory and enums', () {
      expect(
        AssistantCapabilities.localDefaults().canUseVoiceEngine,
        isFalse,
      );
      expect(
        AssistantCapabilities.localVoiceEngine().canUseVoiceEngine,
        isTrue,
      );
      expect(AssistantAudioErrorCode.values, hasLength(8));
      expect(AssistantAudioSensitivity.values, hasLength(7));
      expect(AssistantAudioType.values.length, greaterThanOrEqualTo(8));
    });
  });
}
