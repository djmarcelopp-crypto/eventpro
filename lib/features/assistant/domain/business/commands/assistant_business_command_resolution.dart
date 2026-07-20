import '../capabilities/assistant_business_capability.dart';
import 'assistant_business_command.dart';
import 'assistant_business_command_resolution_status.dart';
import 'assistant_business_command_status.dart';

/// Result of resolving a single command against parameters/context.
///
/// Never executes — only readiness for planning. Capability is resolved
/// solely via the command's [operationCode].
class AssistantBusinessCommandResolution {
  const AssistantBusinessCommandResolution({
    required this.commandId,
    this.command,
    this.resolvedCapability,
    this.resolutionStatus = AssistantBusinessCommandResolutionStatus.blocked,
    this.commandStatus = AssistantBusinessCommandStatus.declared,
    this.messages = const [],
  });

  final String commandId;
  final AssistantBusinessCommand? command;

  /// Capability matched by [AssistantBusinessCommand.operationCode].
  final AssistantBusinessCapability? resolvedCapability;

  final AssistantBusinessCommandResolutionStatus resolutionStatus;
  final AssistantBusinessCommandStatus commandStatus;
  final List<String> messages;

  bool get ready => resolutionStatus.isReady;

  Map<String, Object?> toDeterministicMap() => {
        'commandId': commandId,
        'resolutionStatus': resolutionStatus.name,
        'commandStatus': commandStatus.name,
        'ready': ready,
        'operationCode': command?.operationCode,
        'resolvedCapabilityId': resolvedCapability?.id.value,
        'command': command?.toDeterministicMap(),
        'messages': messages,
      };
}
