import 'assistant_confirmation_operation_kind.dart';
import 'assistant_confirmation_outcome.dart';
import 'assistant_confirmation_token.dart';

/// Planned safe-confirmation request — no ERP side effects.
class AssistantConfirmationRequest {
  const AssistantConfirmationRequest({
    required this.id,
    required this.requestId,
    required this.intentKind,
    this.sessionId,
    this.operationKind,
    this.token,
    this.ttl,
  });

  final String id;
  final String requestId;

  /// create | confirm | cancel | status
  final String intentKind;

  final String? sessionId;
  final AssistantConfirmationOperationKind? operationKind;
  final AssistantConfirmationToken? token;
  final Duration? ttl;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'requestId': requestId,
        'intentKind': intentKind,
        'sessionId': sessionId,
        'operationKind': operationKind?.name,
        'token': token?.value,
        'ttlMs': ttl?.inMilliseconds,
      };
}

/// Capability key for the safe confirmation engine.
abstract final class AssistantSafeConfirmationCapabilities {
  static const safeConfirmation = 'safeConfirmation';
}

/// Intent kinds for [AssistantConfirmationRequest.intentKind].
abstract final class AssistantConfirmationIntentKinds {
  static const create = 'create';
  static const confirm = 'confirm';
  static const cancel = 'cancel';
  static const status = 'status';
}

/// Default TTL for pending confirmations.
abstract final class AssistantConfirmationDefaults {
  static const ttl = Duration(minutes: 5);
}

/// Helper to map outcomes for structured payloads.
extension AssistantConfirmationOutcomeName on AssistantConfirmationOutcome {
  String get wireName => name;
}
