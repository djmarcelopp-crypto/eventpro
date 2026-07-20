import '../../models/assistant_confirmation_operation_kind.dart';
import '../../models/assistant_confirmation_token.dart';
import '../../models/assistant_write_idempotency_key.dart';

/// Validated, ready-to-execute transaction request (no side effects by itself).
class AssistantTransactionExecutionRequest {
  const AssistantTransactionExecutionRequest({
    required this.id,
    required this.requestId,
    required this.sessionId,
    required this.token,
    required this.operationKind,
    required this.attributes,
    required this.planFingerprint,
    required this.idempotencyKey,
  });

  final String id;
  final String requestId;
  final String sessionId;
  final AssistantConfirmationToken token;
  final AssistantConfirmationOperationKind operationKind;
  final Map<String, String> attributes;
  final String planFingerprint;
  final AssistantWriteIdempotencyKey idempotencyKey;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'requestId': requestId,
        'sessionId': sessionId,
        'token': token.value,
        'operationKind': operationKind.name,
        'attributes': attributes,
        'planFingerprint': planFingerprint,
        'idempotencyKey': idempotencyKey.value,
      };
}
