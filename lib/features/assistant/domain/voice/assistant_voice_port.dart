import 'assistant_audio_result.dart';
import 'assistant_audio_types.dart';
import 'assistant_speech.dart';
import 'assistant_transcription.dart';

class AssistantVoiceHealth {
  const AssistantVoiceHealth({
    required this.status,
    required this.checkedAt,
    this.message,
  });

  final AssistantVoiceHealthStatus status;
  final DateTime checkedAt;
  final String? message;

  bool get isHealthy => status == AssistantVoiceHealthStatus.healthy;

  Map<String, Object?> toDeterministicMap() => {
        'status': status.name,
        'checkedAt': checkedAt.toUtc().toIso8601String(),
        'message': message,
      };
}

enum AssistantVoiceHealthStatus {
  healthy,
  degraded,
  unavailable,
  unknown,
}

/// Port for Voice Engine (AI-027 CP-5).
///
/// Produces structured audio facts only. No business decisions / workflows.
abstract class AssistantVoicePort {
  String get engineId;

  Set<AssistantAudioCapability> get capabilities;

  Future<AssistantTranscriptionResult> transcribe(
    AssistantTranscriptionRequest request,
  );

  Future<AssistantSpeechResult> synthesize(AssistantSpeechRequest request);

  Future<AssistantTranscriptLanguage> detectLanguage(
    AssistantAudioRequest request,
  );

  Future<List<AssistantSpeaker>> detectSpeakers(AssistantAudioRequest request);

  Future<AssistantAudioResult> analyzeAudio(AssistantAudioRequest request);

  bool supports(AssistantAudioCapability capability);

  Future<AssistantVoiceHealth> health();
}

class AssistantVoiceSelectionCriteria {
  const AssistantVoiceSelectionCriteria({
    this.audioType,
    this.mimeType,
    this.requiredCapabilities = const {},
    this.preferEngineId,
    this.allowFallback = true,
  });

  final AssistantAudioType? audioType;
  final String? mimeType;
  final Set<AssistantAudioCapability> requiredCapabilities;
  final String? preferEngineId;
  final bool allowFallback;

  Map<String, Object?> toDeterministicMap() => {
        'audioType': audioType?.name,
        'mimeType': mimeType,
        'requiredCapabilities':
            requiredCapabilities.map((c) => c.name).toList()..sort(),
        'preferEngineId': preferEngineId,
        'allowFallback': allowFallback,
      };
}

class AssistantVoiceEngineRegistration {
  const AssistantVoiceEngineRegistration({
    required this.engineId,
    required this.port,
    this.priority = 0,
    this.supportedAudioTypes = const {},
    this.supportedMimePrefixes = const [],
  });

  final String engineId;
  final AssistantVoicePort port;
  final int priority;
  final Set<AssistantAudioType> supportedAudioTypes;
  final List<String> supportedMimePrefixes;

  Map<String, Object?> toDeterministicMap() => {
        'engineId': engineId,
        'priority': priority,
        'supportedAudioTypes':
            supportedAudioTypes.map((t) => t.name).toList()..sort(),
        'supportedMimePrefixes': supportedMimePrefixes,
      };
}

class AssistantVoiceSelection {
  const AssistantVoiceSelection({
    required this.registration,
    required this.reason,
    this.fallbackUsed = false,
  });

  final AssistantVoiceEngineRegistration registration;
  final String reason;
  final bool fallbackUsed;

  AssistantVoicePort get port => registration.port;

  Map<String, Object?> toDeterministicMap() => {
        'engineId': registration.engineId,
        'reason': reason,
        'fallbackUsed': fallbackUsed,
      };
}

abstract class AssistantVoiceRouter {
  void register(AssistantVoiceEngineRegistration registration);

  void unregister(String engineId);

  List<AssistantVoiceEngineRegistration> list();

  AssistantVoiceSelection? select(AssistantVoiceSelectionCriteria criteria);
}
