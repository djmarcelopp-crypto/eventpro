import 'assistant_business_capability.dart';
import 'assistant_business_capability_id.dart';

/// Extensible catalog of declarative business capabilities — no giant switch.
abstract class AssistantBusinessCapabilityRegistry {
  AssistantBusinessCapability? find(AssistantBusinessCapabilityId id);

  AssistantBusinessCapability? findByOperationCode(String operationCode);

  bool contains(AssistantBusinessCapabilityId id) => find(id) != null;

  Iterable<AssistantBusinessCapability> get capabilities;
}
