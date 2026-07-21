import 'assistant_audio_core.dart';
import 'assistant_audio_types.dart';
import 'assistant_transcription.dart';

/// Voice/audio analysis request (structured facts only).
class AssistantAudioRequest {
  const AssistantAudioRequest({
    required this.input,
    this.requestedCapabilities = const {
      AssistantAudioCapability.transcription,
      AssistantAudioCapability.languageDetection,
      AssistantAudioCapability.speakerDetection,
      AssistantAudioCapability.audioAnalysis,
    },
    this.metadata = const AssistantAudioMetadata(),
    this.privacy = const AssistantAudioPrivacyMetadata(),
    this.retention = AssistantAudioRetentionPolicy.defaults,
  });

  final AssistantAudioInput input;
  final Set<AssistantAudioCapability> requestedCapabilities;
  final AssistantAudioMetadata metadata;
  final AssistantAudioPrivacyMetadata privacy;
  final AssistantAudioRetentionPolicy retention;

  Map<String, Object?> toDeterministicMap() => {
        'input': input.toDeterministicMap(),
        'requestedCapabilities':
            requestedCapabilities.map((c) => c.name).toList()..sort(),
        'metadata': metadata.toDeterministicMap(),
        'privacy': privacy.toDeterministicMap(),
        'retention': retention.toDeterministicMap(),
      };
}

/// Business-facing signal only — never an action (AI-027 CP-9).
class AssistantAudioSignal {
  const AssistantAudioSignal({
    required this.code,
    required this.message,
    this.confidence = AssistantAudioConfidence.medium,
  });

  final String code;
  final String message;
  final AssistantAudioConfidence confidence;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
        'confidence': confidence.name,
      };
}

enum AssistantAudioResultStatus {
  ok,
  partial,
  failed,
  restricted,
}

/// Aggregated audio analysis result — facts, not decisions.
class AssistantAudioResult {
  const AssistantAudioResult({
    required this.engineId,
    required this.analyzedAt,
    this.confidence = AssistantAudioConfidence.unknown,
    this.transcription = AssistantTranscriptionResult.empty,
    this.detectedLanguage,
    this.speakers = const [],
    this.signals = const [],
    this.privacy = const AssistantAudioPrivacyMetadata(),
    this.error,
    this.status = AssistantAudioResultStatus.ok,
    this.durationMs,
  });

  final String engineId;
  final DateTime analyzedAt;
  final AssistantAudioConfidence confidence;
  final AssistantTranscriptionResult transcription;
  final AssistantTranscriptLanguage? detectedLanguage;
  final List<AssistantSpeaker> speakers;
  final List<AssistantAudioSignal> signals;
  final AssistantAudioPrivacyMetadata privacy;
  final AssistantAudioError? error;
  final AssistantAudioResultStatus status;
  final int? durationMs;

  bool get isSuccess =>
      status == AssistantAudioResultStatus.ok && error == null;

  Map<String, Object?> toDeterministicMap() => {
        'engineId': engineId,
        'analyzedAt': analyzedAt.toUtc().toIso8601String(),
        'confidence': confidence.name,
        'transcription': transcription.toDeterministicMap(),
        'detectedLanguage': detectedLanguage?.toDeterministicMap(),
        'speakers': speakers.map((s) => s.toDeterministicMap()).toList(),
        'signals': signals.map((s) => s.toDeterministicMap()).toList(),
        'privacy': privacy.toDeterministicMap(),
        'error': error?.toDeterministicMap(),
        'status': status.name,
        'durationMs': durationMs,
      };
}

/// Observability record (AI-027 CP-11) — contracts only.
class AssistantAudioObservation {
  const AssistantAudioObservation({
    required this.operation,
    required this.engineId,
    required this.timestamp,
    required this.status,
    this.confidence,
    this.durationMs,
    this.segmentCount = 0,
    this.speakerCount = 0,
    this.wordCount = 0,
    this.latencyMs,
    this.correlationId,
    this.errorCode,
  });

  final String operation;
  final String engineId;
  final DateTime timestamp;
  final String status;
  final AssistantAudioConfidence? confidence;
  final int? durationMs;
  final int segmentCount;
  final int speakerCount;
  final int wordCount;
  final int? latencyMs;
  final String? correlationId;
  final String? errorCode;

  Map<String, Object?> toDeterministicMap() => {
        'operation': operation,
        'engineId': engineId,
        'timestamp': timestamp.toUtc().toIso8601String(),
        'status': status,
        'confidence': confidence?.name,
        'durationMs': durationMs,
        'segmentCount': segmentCount,
        'speakerCount': speakerCount,
        'wordCount': wordCount,
        'latencyMs': latencyMs,
        'correlationId': correlationId,
        'errorCode': errorCode,
      };
}

abstract class AssistantAudioObserver {
  void record(AssistantAudioObservation observation);
}

class NoopAssistantAudioObserver implements AssistantAudioObserver {
  const NoopAssistantAudioObserver();

  @override
  void record(AssistantAudioObservation observation) {}
}

class CollectingAssistantAudioObserver implements AssistantAudioObserver {
  CollectingAssistantAudioObserver();

  final List<AssistantAudioObservation> records = [];

  @override
  void record(AssistantAudioObservation observation) {
    records.add(observation);
  }
}
