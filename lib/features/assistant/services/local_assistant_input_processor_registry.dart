import '../domain/input/assistant_input_processor.dart';
import '../domain/input/assistant_input_processor_id.dart';
import '../domain/input/assistant_input_processor_registry.dart';
import '../domain/input/assistant_input_type.dart';
import 'local_assistant_text_input_processor.dart';

/// In-memory processor registry — immutable extension via [register].
class LocalAssistantInputProcessorRegistry
    implements AssistantInputProcessorRegistry {
  LocalAssistantInputProcessorRegistry([
    Map<String, AssistantInputProcessor>? byId,
  ]) : _byId = Map.unmodifiable(byId ?? const {});

  final Map<String, AssistantInputProcessor> _byId;

  factory LocalAssistantInputProcessorRegistry.defaults() {
    const text = LocalAssistantTextInputProcessor();
    return LocalAssistantInputProcessorRegistry({
      text.id.value: text,
    });
  }

  /// Empty registry — no processors (safe absence).
  factory LocalAssistantInputProcessorRegistry.empty() =>
      LocalAssistantInputProcessorRegistry(const {});

  LocalAssistantInputProcessorRegistry register(
    AssistantInputProcessor processor,
  ) {
    return LocalAssistantInputProcessorRegistry({
      ..._byId,
      processor.id.value: processor,
    });
  }

  @override
  AssistantInputProcessor? find(AssistantInputProcessorId id) =>
      _byId[id.value];

  @override
  AssistantInputProcessor? findByType(AssistantInputType type) {
    for (final p in _byId.values) {
      if (p.supportedTypes.contains(type)) return p;
    }
    return null;
  }

  @override
  AssistantInputProcessor? findByMimeType(String mimeType) {
    final mime = mimeType.trim().toLowerCase();
    for (final p in _byId.values) {
      if (p.supportedMimeTypes.contains(mime)) return p;
    }
    return null;
  }

  @override
  bool contains(AssistantInputProcessorId id) => _byId.containsKey(id.value);

  @override
  Iterable<AssistantInputProcessor> get processors => _byId.values;
}
