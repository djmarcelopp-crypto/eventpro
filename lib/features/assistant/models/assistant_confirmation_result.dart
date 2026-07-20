import 'assistant_confirmation_metadata.dart';
import 'assistant_confirmation_outcome.dart';
import 'assistant_confirmation_warning.dart';
import 'pending_confirmation.dart';

/// Outcome of a safe confirmation turn (never mutates ERP).
class AssistantConfirmationResult {
  const AssistantConfirmationResult({
    required this.requestId,
    required this.outcome,
    required this.warnings,
    required this.metadata,
    this.pending,
    this.preview,
    this.summary,
    this.valid = true,
  });

  final String requestId;
  final AssistantConfirmationOutcome outcome;
  final List<AssistantConfirmationWarning> warnings;
  final AssistantConfirmationMetadata metadata;
  final PendingConfirmation? pending;
  final String? preview;
  final String? summary;
  final bool valid;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'outcome': outcome.name,
        'valid': valid,
        'summary': summary,
        'preview': preview,
        'pending': pending?.toDeterministicMap(),
        'warnings': warnings.map((w) => w.toDeterministicMap()).toList(),
        'metadata': metadata.toDeterministicMap(),
      };
}
