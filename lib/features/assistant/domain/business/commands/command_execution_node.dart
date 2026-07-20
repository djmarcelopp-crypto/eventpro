import 'assistant_business_command_category.dart';
import 'assistant_business_command_id.dart';
import 'assistant_business_command_resolution.dart';
import 'assistant_business_command_resolution_status.dart';
import 'assistant_business_command_version.dart';

/// Ordered planning node linking a workflow business step to a command
/// resolution. Declarative only — does not execute.
class CommandExecutionNode {
  const CommandExecutionNode({
    required this.plannerOrder,
    required this.commandId,
    required this.status,
    required this.resolution,
    this.version,
    this.category,
    this.operationCode,
    this.stepId,
    this.dependencyIndexes = const [],
    this.producedOutputs = const [],
  });

  /// Explicit planner order (0-based).
  final int plannerOrder;

  final AssistantBusinessCommandId commandId;
  final AssistantBusinessCommandVersion? version;
  final AssistantBusinessCommandCategory? category;

  /// Resolution status for this planned command.
  final AssistantBusinessCommandResolutionStatus status;
  final AssistantBusinessCommandResolution resolution;
  final String? operationCode;
  final String? stepId;

  /// Indexes ([plannerOrder]) of prior command nodes this node depends on.
  final List<int> dependencyIndexes;

  /// Output keys this command declares it will produce.
  final List<String> producedOutputs;

  bool get ready => status.isReady;

  /// Alias of [plannerOrder] for list positioning.
  int get index => plannerOrder;

  Map<String, Object?> toDeterministicMap() => {
        'plannerOrder': plannerOrder,
        'commandId': commandId.toDeterministicMap(),
        'version': version?.toDeterministicMap(),
        'category': category?.name,
        'status': status.name,
        'operationCode': operationCode,
        'stepId': stepId,
        'dependencyIndexes': dependencyIndexes,
        'producedOutputs': producedOutputs,
        'resolution': resolution.toDeterministicMap(),
      };
}
