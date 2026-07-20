import 'assistant_input_processor.dart';
import 'assistant_input_processor_id.dart';
import 'assistant_input_type.dart';

/// Extensible catalog of multimodal processors — no giant switch.
abstract class AssistantInputProcessorRegistry {
  AssistantInputProcessor? find(AssistantInputProcessorId id);

  AssistantInputProcessor? findByType(AssistantInputType type);

  AssistantInputProcessor? findByMimeType(String mimeType);

  bool contains(AssistantInputProcessorId id) => find(id) != null;

  Iterable<AssistantInputProcessor> get processors;
}
