import 'assistant_business_capability_category.dart';
import 'assistant_business_capability_constraint.dart';
import 'assistant_business_capability_id.dart';
import 'assistant_business_capability_input.dart';
import 'assistant_business_capability_metadata.dart';
import 'assistant_business_capability_output.dart';
import 'assistant_business_capability_version.dart';

/// Immutable declarative business capability — describes, does not execute.
class AssistantBusinessCapability {
  const AssistantBusinessCapability({
    required this.id,
    required this.metadata,
    this.version = AssistantBusinessCapabilityVersion.v1,
    this.category = AssistantBusinessCapabilityCategory.other,
    this.inputs = const [],
    this.outputs = const [],
    this.constraints = const [],
  });

  final AssistantBusinessCapabilityId id;
  final AssistantBusinessCapabilityVersion version;
  final AssistantBusinessCapabilityCategory category;
  final AssistantBusinessCapabilityMetadata metadata;
  final List<AssistantBusinessCapabilityInput> inputs;
  final List<AssistantBusinessCapabilityOutput> outputs;
  final List<AssistantBusinessCapabilityConstraint> constraints;

  String get operationCode =>
      metadata.operationCode ?? id.value.toUpperCase();

  Map<String, Object?> toDeterministicMap() => {
        'id': id.toDeterministicMap(),
        'version': version.toDeterministicMap(),
        'category': category.name,
        'metadata': metadata.toDeterministicMap(),
        'inputs': inputs.map((i) => i.toDeterministicMap()).toList(),
        'outputs': outputs.map((o) => o.toDeterministicMap()).toList(),
        'constraints':
            constraints.map((c) => c.toDeterministicMap()).toList(),
      };
}
