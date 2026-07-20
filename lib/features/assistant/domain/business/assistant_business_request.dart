import 'assistant_business_operation.dart';
import 'assistant_business_reference.dart';

/// Immutable request to invoke a registered business operation.
class AssistantBusinessRequest {
  const AssistantBusinessRequest({
    required this.requestId,
    required this.operation,
    this.params = const {},
    this.clientReference,
    this.quoteReference,
    this.eventReference,
    this.contractReference,
  });

  final String requestId;
  final AssistantBusinessOperation operation;
  final Map<String, String> params;
  final ClientReference? clientReference;
  final QuoteReference? quoteReference;
  final EventReference? eventReference;
  final ContractReference? contractReference;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'operation': operation.toDeterministicMap(),
        'params': params,
        'clientReference': clientReference?.toDeterministicMap(),
        'quoteReference': quoteReference?.toDeterministicMap(),
        'eventReference': eventReference?.toDeterministicMap(),
        'contractReference': contractReference?.toDeterministicMap(),
      };
}
