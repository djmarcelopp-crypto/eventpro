import 'assistant_business_operation.dart';
import 'assistant_business_reference.dart';
import 'assistant_business_status.dart';
import 'assistant_business_warning.dart';

/// Immutable result of a business operation (no ERP entities).
class AssistantBusinessResult {
  const AssistantBusinessResult({
    required this.requestId,
    required this.operation,
    required this.status,
    this.reference,
    this.clientReference,
    this.quoteReference,
    this.eventReference,
    this.contractReference,
    this.message,
    this.outputs = const {},
    this.warnings = const [],
    this.valid = true,
  });

  final String requestId;
  final AssistantBusinessOperation operation;
  final AssistantBusinessStatus status;

  /// Primary reference produced or resolved by the operation.
  final AssistantBusinessReference? reference;
  final ClientReference? clientReference;
  final QuoteReference? quoteReference;
  final EventReference? eventReference;
  final ContractReference? contractReference;
  final String? message;
  final Map<String, Object?> outputs;
  final List<AssistantBusinessWarning> warnings;
  final bool valid;

  bool get succeeded => status == AssistantBusinessStatus.succeeded;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'operation': operation.toDeterministicMap(),
        'status': status.name,
        'valid': valid,
        'message': message,
        'reference': reference?.toDeterministicMap(),
        'clientReference': clientReference?.toDeterministicMap(),
        'quoteReference': quoteReference?.toDeterministicMap(),
        'eventReference': eventReference?.toDeterministicMap(),
        'contractReference': contractReference?.toDeterministicMap(),
        'outputs': outputs,
        'warnings': warnings.map((w) => w.toDeterministicMap()).toList(),
      };
}
