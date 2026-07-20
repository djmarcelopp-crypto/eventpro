import 'assistant_business_command_category.dart';
import 'assistant_business_command_id.dart';
import 'assistant_business_command_metadata.dart';
import 'assistant_business_command_parameter.dart';
import 'assistant_business_command_result.dart';
import 'assistant_business_command_version.dart';

/// Immutable declarative business command — describes, does not execute.
///
/// Declares [operationCode] only; Capability is resolved by the CommandResolver.
class AssistantBusinessCommand {
  const AssistantBusinessCommand({
    required this.id,
    required this.metadata,
    this.version = AssistantBusinessCommandVersion.v1,
    this.category = AssistantBusinessCommandCategory.other,
    this.parameters = const [],
    this.results = const [],
  });

  final AssistantBusinessCommandId id;
  final AssistantBusinessCommandVersion version;
  final AssistantBusinessCommandCategory category;
  final AssistantBusinessCommandMetadata metadata;
  final List<AssistantBusinessCommandParameter> parameters;
  final List<AssistantBusinessCommandResult> results;

  String get operationCode =>
      metadata.operationCode ?? id.value.toUpperCase();

  Map<String, Object?> toDeterministicMap() => {
        'id': id.toDeterministicMap(),
        'version': version.toDeterministicMap(),
        'category': category.name,
        'metadata': metadata.toDeterministicMap(),
        'parameters': parameters.map((p) => p.toDeterministicMap()).toList(),
        'results': results.map((r) => r.toDeterministicMap()).toList(),
      };
}
