import '../../models/assistant_execution_context.dart';
import '../../models/assistant_write_idempotency_key.dart';
import '../../models/assistant_write_payload.dart';
import '../../models/assistant_write_request.dart';
import '../../models/assistant_write_transaction_status.dart';

/// Immutable write transaction prepared by the assistant pipeline.
///
/// Carries only validated intent + context — never ERP entities.
class AssistantWriteTransaction {
  const AssistantWriteTransaction({
    required this.id,
    required this.request,
    required this.payload,
    required this.context,
    required this.idempotencyKey,
    this.status = AssistantWriteTransactionStatus.pending,
    this.adapterName = '',
  });

  final String id;
  final AssistantWriteRequest request;
  final AssistantWritePayload payload;
  final AssistantExecutionContext context;
  final AssistantWriteIdempotencyKey idempotencyKey;
  final AssistantWriteTransactionStatus status;
  final String adapterName;

  AssistantWriteTransaction copyWith({
    String? id,
    AssistantWriteRequest? request,
    AssistantWritePayload? payload,
    AssistantExecutionContext? context,
    AssistantWriteIdempotencyKey? idempotencyKey,
    AssistantWriteTransactionStatus? status,
    String? adapterName,
  }) {
    return AssistantWriteTransaction(
      id: id ?? this.id,
      request: request ?? this.request,
      payload: payload ?? this.payload,
      context: context ?? this.context,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      status: status ?? this.status,
      adapterName: adapterName ?? this.adapterName,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWriteTransaction &&
            other.id == id &&
            other.request == request &&
            other.payload == payload &&
            other.context == context &&
            other.idempotencyKey == idempotencyKey &&
            other.status == status &&
            other.adapterName == adapterName;
  }

  @override
  int get hashCode => Object.hash(
        id,
        request,
        payload,
        context,
        idempotencyKey,
        status,
        adapterName,
      );
}
