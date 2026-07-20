import '../domain/business/assistant_business_gateway.dart';
import '../domain/business/assistant_business_registry.dart';
import '../domain/business/assistant_business_request.dart';
import '../domain/business/assistant_business_result.dart';
import '../domain/business/assistant_business_status.dart';
import '../domain/business/assistant_business_warning.dart';
import 'local_assistant_business_registry.dart';

/// Local gateway — resolves operations via [AssistantBusinessRegistry].
///
/// Contains no ERP business rules; only registry lookup + handler dispatch.
class LocalAssistantBusinessGateway implements AssistantBusinessGateway {
  LocalAssistantBusinessGateway({
    AssistantBusinessRegistry? registry,
  }) : _registry = registry ?? LocalAssistantBusinessRegistry.defaults();

  final AssistantBusinessRegistry _registry;

  AssistantBusinessRegistry get registry => _registry;

  @override
  Future<AssistantBusinessResult> execute(
    AssistantBusinessRequest request,
  ) async {
    final code = request.operation.code;
    final registered = _registry.find(code);
    final handler = _registry.handlerFor(code);
    if (registered == null || handler == null) {
      return AssistantBusinessResult(
        requestId: request.requestId,
        operation: request.operation,
        status: AssistantBusinessStatus.unavailable,
        valid: false,
        message: 'Operação $code não registrada.',
        warnings: [
          AssistantBusinessWarning(
            code: AssistantBusinessWarning.notRegistered,
            message: 'Nenhum handler para $code.',
          ),
        ],
      );
    }

    final normalized = AssistantBusinessRequest(
      requestId: request.requestId,
      operation: registered,
      params: request.params,
      clientReference: request.clientReference,
      quoteReference: request.quoteReference,
      eventReference: request.eventReference,
      contractReference: request.contractReference,
    );
    return handler.handle(normalized);
  }
}
