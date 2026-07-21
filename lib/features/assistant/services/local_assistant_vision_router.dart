import '../domain/vision/assistant_vision_port.dart';
import '../domain/vision/assistant_vision_types.dart';

/// Deterministic vision engine router (AI-026 CP-8).
class LocalAssistantVisionRouter implements AssistantVisionRouter {
  LocalAssistantVisionRouter();

  final Map<String, AssistantVisionEngineRegistration> _byId = {};

  @override
  void register(AssistantVisionEngineRegistration registration) {
    _byId[registration.engineId] = registration;
  }

  @override
  void unregister(String engineId) {
    _byId.remove(engineId);
  }

  @override
  List<AssistantVisionEngineRegistration> list() =>
      List.unmodifiable(_byId.values.toList());

  @override
  AssistantVisionSelection? select(
    AssistantVisionSelectionCriteria criteria,
  ) {
    final all = _byId.values.toList();
    if (all.isEmpty) return null;

    if (criteria.preferEngineId != null) {
      final preferred = _byId[criteria.preferEngineId!];
      if (preferred != null && _matches(preferred, criteria)) {
        return AssistantVisionSelection(
          registration: preferred,
          reason: 'prefer_engine_id',
        );
      }
      if (!criteria.allowFallback) return null;
    }

    final matching = all.where((r) => _matches(r, criteria)).toList();
    if (matching.isNotEmpty) {
      matching.sort(_byPriorityDesc);
      return AssistantVisionSelection(
        registration: matching.first,
        reason: 'capability_priority',
      );
    }

    if (!criteria.allowFallback) return null;
    final sorted = [...all]..sort(_byPriorityDesc);
    return AssistantVisionSelection(
      registration: sorted.first,
      reason: 'default_fallback',
      fallbackUsed: true,
    );
  }

  bool _matches(
    AssistantVisionEngineRegistration registration,
    AssistantVisionSelectionCriteria criteria,
  ) {
    for (final cap in criteria.requiredCapabilities) {
      if (!registration.port.supports(cap)) return false;
    }

    if (criteria.inputType != null &&
        registration.supportedInputTypes.isNotEmpty &&
        !registration.supportedInputTypes.contains(criteria.inputType) &&
        !registration.supportedInputTypes
            .contains(AssistantVisionInputType.unknown)) {
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
    AssistantVisionEngineRegistration a,
    AssistantVisionEngineRegistration b,
  ) {
    final byPriority = b.priority.compareTo(a.priority);
    if (byPriority != 0) return byPriority;
    return a.engineId.compareTo(b.engineId);
  }

  void clear() => _byId.clear();
}
