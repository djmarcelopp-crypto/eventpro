import 'assistant_action_metadata.dart';
import 'assistant_action_warning.dart';
import 'assistant_nav_action.dart';

/// Outcome of a smart-action execution (navigation directive only).
class AssistantActionResult {
  const AssistantActionResult({
    required this.requestId,
    required this.actions,
    required this.warnings,
    required this.metadata,
    this.valid = true,
    this.executed = false,
    this.failureMessage,
    this.summary,
  });

  final String requestId;
  final List<AssistantNavAction> actions;
  final List<AssistantActionWarning> warnings;
  final AssistantActionMetadata metadata;
  final bool valid;
  final bool executed;
  final String? failureMessage;
  final String? summary;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'valid': valid,
        'executed': executed,
        'failureMessage': failureMessage,
        'summary': summary,
        'actions': actions.map((a) => a.toDeterministicMap()).toList(),
        'warnings': warnings.map((w) => w.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
      };
}
