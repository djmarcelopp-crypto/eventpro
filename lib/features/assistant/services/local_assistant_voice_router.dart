import '../domain/voice/assistant_audio_types.dart';
import '../domain/voice/assistant_voice_port.dart';

/// Deterministic voice engine router (AI-027 CP-7).
class LocalAssistantVoiceRouter implements AssistantVoiceRouter {
  LocalAssistantVoiceRouter();

  final Map<String, AssistantVoiceEngineRegistration> _byId = {};

  @override
  void register(AssistantVoiceEngineRegistration registration) {
    _byId[registration.engineId] = registration;
  }

  @override
  void unregister(String engineId) {
    _byId.remove(engineId);
  }

  @override
  List<AssistantVoiceEngineRegistration> list() =>
      List.unmodifiable(_byId.values.toList());

  @override
  AssistantVoiceSelection? select(AssistantVoiceSelectionCriteria criteria) {
    final all = _byId.values.toList();
    if (all.isEmpty) return null;

    if (criteria.preferEngineId != null) {
      final preferred = _byId[criteria.preferEngineId!];
      if (preferred != null && _matches(preferred, criteria)) {
        return AssistantVoiceSelection(
          registration: preferred,
          reason: 'prefer_engine_id',
        );
      }
      if (!criteria.allowFallback) return null;
    }

    final matching = all.where((r) => _matches(r, criteria)).toList();
    if (matching.isNotEmpty) {
      matching.sort(_byPriorityDesc);
      return AssistantVoiceSelection(
        registration: matching.first,
        reason: 'capability_priority',
      );
    }

    if (!criteria.allowFallback) return null;
    final sorted = [...all]..sort(_byPriorityDesc);
    return AssistantVoiceSelection(
      registration: sorted.first,
      reason: 'default_fallback',
      fallbackUsed: true,
    );
  }

  bool _matches(
    AssistantVoiceEngineRegistration registration,
    AssistantVoiceSelectionCriteria criteria,
  ) {
    for (final cap in criteria.requiredCapabilities) {
      if (!registration.port.supports(cap)) return false;
    }

    if (criteria.audioType != null &&
        registration.supportedAudioTypes.isNotEmpty &&
        !registration.supportedAudioTypes.contains(criteria.audioType) &&
        !registration.supportedAudioTypes.contains(AssistantAudioType.unknown)) {
      return false;
    }

    final mime = criteria.mimeType?.toLowerCase();
    if (mime != null &&
        mime.isNotEmpty &&
        registration.supportedMimePrefixes.isNotEmpty) {
      final ok = registration.supportedMimePrefixes
          .any((p) => mime.startsWith(p.toLowerCase()));
      if (!ok) return false;
    }

    return true;
  }

  int _byPriorityDesc(
    AssistantVoiceEngineRegistration a,
    AssistantVoiceEngineRegistration b,
  ) {
    final byPriority = b.priority.compareTo(a.priority);
    if (byPriority != 0) return byPriority;
    return a.engineId.compareTo(b.engineId);
  }

  void clear() => _byId.clear();
}
