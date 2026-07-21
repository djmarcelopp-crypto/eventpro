import '../domain/voice/assistant_audio_core.dart';
import '../domain/voice/assistant_audio_result.dart';
import '../domain/voice/assistant_audio_types.dart';
import '../domain/voice/assistant_speech.dart';
import '../domain/voice/assistant_transcription.dart';
import '../domain/voice/assistant_voice_port.dart';

/// Deterministic mock Voice Engine (AI-027 CP-6).
///
/// No STT/TTS, HTTP, SDKs, or real audio — keyword rules on references.
class LocalMockVoiceEngine implements AssistantVoicePort {
  LocalMockVoiceEngine({
    this.engineId = defaultEngineId,
    AssistantAudioObserver? observer,
    DateTime Function()? clock,
  })  : _observer = observer ?? const NoopAssistantAudioObserver(),
        _clock = clock ?? DateTime.now;

  static const defaultEngineId = 'local.mock.voice';

  @override
  final String engineId;

  final AssistantAudioObserver _observer;
  final DateTime Function() _clock;

  static const _caps = {
    AssistantAudioCapability.transcription,
    AssistantAudioCapability.synthesis,
    AssistantAudioCapability.languageDetection,
    AssistantAudioCapability.speakerDetection,
    AssistantAudioCapability.audioAnalysis,
  };

  @override
  Set<AssistantAudioCapability> get capabilities => _caps;

  static AssistantVoiceEngineRegistration registration({
    LocalMockVoiceEngine? port,
    int priority = 0,
  }) {
    final engine = port ?? LocalMockVoiceEngine();
    return AssistantVoiceEngineRegistration(
      engineId: engine.engineId,
      port: engine,
      priority: priority,
      supportedAudioTypes: AssistantAudioType.values.toSet(),
      supportedMimePrefixes: const [
        'audio/',
        'application/octet-stream',
      ],
    );
  }

  @override
  bool supports(AssistantAudioCapability capability) =>
      _caps.contains(capability);

  @override
  Future<AssistantVoiceHealth> health() async {
    return AssistantVoiceHealth(
      status: AssistantVoiceHealthStatus.healthy,
      checkedAt: _clock().toUtc(),
      message: 'local.mock.voice ready',
    );
  }

  @override
  Future<AssistantTranscriptionResult> transcribe(
    AssistantTranscriptionRequest request,
  ) async {
    final label = _normalize(request.fileName ?? request.referenceUri);
    final text = _simulatedTranscript(label);
    final confidence = label.isEmpty || _isUnknown(label)
        ? AssistantAudioConfidence.low
        : AssistantAudioConfidence.high;
    final speaker = const AssistantSpeaker(
      id: AssistantSpeakerId('spk-1'),
      label: 'speaker_1',
      confidence: AssistantAudioConfidence.medium,
    );
    final words = text
        .split(RegExp(r'\s+'))
        .where((w) => w.isNotEmpty)
        .toList(growable: false);
    final segment = AssistantTranscriptSegment(
      text: text,
      startMs: 0,
      endMs: (words.length * 350).clamp(500, 60000),
      speakerId: speaker.id,
      confidence: confidence,
      words: [
        for (var i = 0; i < words.length; i++)
          AssistantTranscriptWord(
            text: words[i],
            startMs: i * 350,
            endMs: (i + 1) * 350,
            confidence: 0.7,
          ),
      ],
    );
    return AssistantTranscriptionResult(
      fullText: text,
      segments: [segment],
      speakers: [speaker],
      language: AssistantTranscriptLanguage(
        code: request.languageHint ?? 'pt',
        confidence: AssistantAudioConfidence.medium,
      ),
      confidence: confidence,
      metadata: AssistantTranscriptMetadata(
        correlationId: request.correlationId,
        language: request.languageHint ?? 'pt',
        engineId: engineId,
        wordCount: words.length,
        segmentCount: 1,
      ),
    );
  }

  @override
  Future<AssistantSpeechResult> synthesize(
    AssistantSpeechRequest request,
  ) async {
    // Contracts only — no real TTS / bytes.
    final profile = request.voiceProfileId ?? 'mock-voice-pt';
    return AssistantSpeechResult(
      audioReferenceUri: 'mock-tts://$profile/${request.text.hashCode}',
      voiceProfileId: profile,
      metadata: AssistantSpeechMetadata(
        correlationId: request.correlationId,
        voiceProfileId: profile,
        format: 'mock/reference',
        estimatedDurationMs: (request.text.length * 60).clamp(200, 120000),
      ),
    );
  }

  @override
  Future<AssistantTranscriptLanguage> detectLanguage(
    AssistantAudioRequest request,
  ) async {
    final hint = request.input.language ??
        request.metadata.language ??
        request.metadata.locale;
    if (hint != null && hint.trim().isNotEmpty) {
      return AssistantTranscriptLanguage(
        code: hint.split('_').first.toLowerCase(),
        confidence: AssistantAudioConfidence.medium,
      );
    }
    return const AssistantTranscriptLanguage(
      code: 'pt',
      confidence: AssistantAudioConfidence.low,
    );
  }

  @override
  Future<List<AssistantSpeaker>> detectSpeakers(
    AssistantAudioRequest request,
  ) async {
    final label = _normalize(request.input.reference.label);
    if (label.contains('reuniao') ||
        label.contains('meeting') ||
        label.contains('call')) {
      return const [
        AssistantSpeaker(
          id: AssistantSpeakerId('spk-1'),
          label: 'speaker_1',
          confidence: AssistantAudioConfidence.medium,
        ),
        AssistantSpeaker(
          id: AssistantSpeakerId('spk-2'),
          label: 'speaker_2',
          confidence: AssistantAudioConfidence.medium,
        ),
      ];
    }
    return const [
      AssistantSpeaker(
        id: AssistantSpeakerId('spk-1'),
        label: 'speaker_1',
        confidence: AssistantAudioConfidence.medium,
      ),
    ];
  }

  @override
  Future<AssistantAudioResult> analyzeAudio(
    AssistantAudioRequest request,
  ) async {
    final started = _clock().toUtc();
    if (!request.input.reference.isValid) {
      return _fail(
        request,
        started,
        const AssistantAudioError(
          code: AssistantAudioErrorCode.invalidReference,
          message: 'Audio reference is empty',
        ),
      );
    }

    if (request.privacy.sensitivity == AssistantAudioSensitivity.personalData &&
        request.privacy.redacted) {
      return AssistantAudioResult(
        engineId: engineId,
        analyzedAt: started,
        status: AssistantAudioResultStatus.restricted,
        confidence: AssistantAudioConfidence.low,
        privacy: request.privacy,
        error: const AssistantAudioError(
          code: AssistantAudioErrorCode.privacyRestricted,
          message: 'Analysis restricted by privacy metadata',
        ),
      );
    }

    final label = _normalize(request.input.reference.label);
    final transcription = await transcribe(
      AssistantTranscriptionRequest(
        referenceUri: request.input.reference.uri,
        fileName: request.input.reference.fileName,
        mimeType: request.input.reference.mimeType,
        languageHint: request.input.language ?? request.metadata.language,
        correlationId: request.metadata.correlationId,
      ),
    );
    final language = await detectLanguage(request);
    final speakers = await detectSpeakers(request);
    final signals = _buildSignals(label);
    final confidence = _isUnknown(label)
        ? AssistantAudioConfidence.low
        : (signals.isEmpty
            ? AssistantAudioConfidence.low
            : AssistantAudioConfidence.high);
    final privacy = _inferPrivacy(label);

    final result = AssistantAudioResult(
      engineId: engineId,
      analyzedAt: started,
      confidence: confidence,
      transcription: transcription,
      detectedLanguage: language,
      speakers: speakers,
      signals: signals,
      privacy: privacy,
      status: AssistantAudioResultStatus.ok,
      durationMs: request.input.reference.durationMs ??
          transcription.segments.firstOrNull?.endMs,
    );

    _observe(
      operation: 'analyzeAudio',
      request: request,
      result: result,
      started: started,
    );
    return result;
  }

  String _simulatedTranscript(String label) {
    if (label.contains('cliente')) {
      return 'mock-stt: cliente mencionado na conversa';
    }
    if (label.contains('evento')) {
      return 'mock-stt: evento detectado na conversa';
    }
    if (label.contains('contrato')) {
      return 'mock-stt: menção a contrato';
    }
    if (label.contains('pagamento')) {
      return 'mock-stt: pagamento identificado';
    }
    if (label.contains('palco')) {
      return 'mock-stt: equipamentos mencionados no palco';
    }
    if (label.isEmpty) return 'mock-stt:empty';
    return 'mock-stt:unknown:$label';
  }

  List<AssistantAudioSignal> _buildSignals(String label) {
    final signals = <AssistantAudioSignal>[];
    if (label.contains('cliente')) {
      signals.add(
        const AssistantAudioSignal(
          code: 'client_mentioned',
          message: 'Cliente mencionado',
          confidence: AssistantAudioConfidence.high,
        ),
      );
    }
    if (label.contains('evento')) {
      signals.add(
        const AssistantAudioSignal(
          code: 'event_mentioned',
          message: 'Evento mencionado',
          confidence: AssistantAudioConfidence.high,
        ),
      );
    }
    if (label.contains('pagamento')) {
      signals.add(
        const AssistantAudioSignal(
          code: 'payment_mentioned',
          message: 'Pagamento mencionado',
          confidence: AssistantAudioConfidence.high,
        ),
      );
    }
    if (label.contains('contrato')) {
      signals.add(
        const AssistantAudioSignal(
          code: 'contract_mentioned',
          message: 'Contrato mencionado',
          confidence: AssistantAudioConfidence.high,
        ),
      );
    }
    if (label.contains('palco') || label.contains('equip')) {
      signals.add(
        const AssistantAudioSignal(
          code: 'equipment_mentioned',
          message: 'Equipamento mencionado',
          confidence: AssistantAudioConfidence.medium,
        ),
      );
    }
    if (_isUnknown(label)) {
      signals.add(
        const AssistantAudioSignal(
          code: 'unknown_low_confidence',
          message: 'Áudio desconhecido com baixa confiança',
          confidence: AssistantAudioConfidence.low,
        ),
      );
    }
    return signals;
  }

  bool _isUnknown(String label) {
    if (label.isEmpty) return true;
    const keys = [
      'cliente',
      'evento',
      'contrato',
      'pagamento',
      'palco',
      'equip',
    ];
    return !keys.any(label.contains);
  }

  AssistantAudioPrivacyMetadata _inferPrivacy(String label) {
    if (label.contains('pagamento') || label.contains('pix')) {
      return const AssistantAudioPrivacyMetadata(
        sensitivity: AssistantAudioSensitivity.financial,
        containsFinancialData: true,
      );
    }
    if (label.contains('contrato') || label.contains('legal')) {
      return const AssistantAudioPrivacyMetadata(
        sensitivity: AssistantAudioSensitivity.legal,
      );
    }
    if (label.contains('cliente') || label.contains('cpf')) {
      return const AssistantAudioPrivacyMetadata(
        sensitivity: AssistantAudioSensitivity.personalData,
        containsPersonalData: true,
      );
    }
    return const AssistantAudioPrivacyMetadata(
      sensitivity: AssistantAudioSensitivity.internal,
    );
  }

  AssistantAudioResult _fail(
    AssistantAudioRequest request,
    DateTime started,
    AssistantAudioError error,
  ) {
    final result = AssistantAudioResult(
      engineId: engineId,
      analyzedAt: started,
      status: AssistantAudioResultStatus.failed,
      confidence: AssistantAudioConfidence.unknown,
      error: error,
      privacy: request.privacy,
    );
    _observe(
      operation: 'analyzeAudio',
      request: request,
      result: result,
      started: started,
    );
    return result;
  }

  void _observe({
    required String operation,
    required AssistantAudioRequest request,
    required AssistantAudioResult result,
    required DateTime started,
  }) {
    final ended = _clock().toUtc();
    _observer.record(
      AssistantAudioObservation(
        operation: operation,
        engineId: engineId,
        timestamp: ended,
        status: result.status.name,
        confidence: result.confidence,
        durationMs: result.durationMs,
        segmentCount: result.transcription.segments.length,
        speakerCount: result.speakers.length,
        wordCount: result.transcription.metadata.wordCount,
        latencyMs: ended.difference(started).inMilliseconds,
        correlationId: request.metadata.correlationId,
        errorCode: result.error?.code.name,
      ),
    );
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }
}

extension _FirstOrNull<E> on List<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
