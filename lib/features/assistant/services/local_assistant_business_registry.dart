import '../domain/business/assistant_business_operation.dart';
import '../domain/business/assistant_business_reference.dart';
import '../domain/business/assistant_business_registry.dart';
import '../domain/business/assistant_business_request.dart';
import '../domain/business/assistant_business_result.dart';
import '../domain/business/assistant_business_status.dart';
import '../domain/business/assistant_business_warning.dart';

/// In-memory stub handlers — no Drift, HTTP, or ERP rules.
class _StubFindClientHandler implements AssistantBusinessOperationHandler {
  @override
  Future<AssistantBusinessResult> handle(AssistantBusinessRequest request) async {
    final query = request.params['query']?.trim();
    final id = (query != null && query.isNotEmpty)
        ? 'client-stub-${query.toLowerCase().replaceAll(' ', '-')}'
        : 'client-stub-default';
    final ref = ClientReference(id: id, label: query ?? 'Cliente stub');
    return AssistantBusinessResult(
      requestId: request.requestId,
      operation: request.operation,
      status: AssistantBusinessStatus.succeeded,
      reference: ref,
      clientReference: ref,
      message: 'Cliente localizado (stub).',
      warnings: const [
        AssistantBusinessWarning(
          code: AssistantBusinessWarning.stubOnly,
          message: 'Resultado stub — sem acesso a ERP.',
        ),
      ],
    );
  }
}

class _StubCreateQuoteHandler implements AssistantBusinessOperationHandler {
  @override
  Future<AssistantBusinessResult> handle(AssistantBusinessRequest request) async {
    final client = request.clientReference;
    if (client == null) {
      return AssistantBusinessResult(
        requestId: request.requestId,
        operation: request.operation,
        status: AssistantBusinessStatus.rejected,
        valid: false,
        message: 'CREATE_QUOTE requer clientReference.',
        warnings: const [
          AssistantBusinessWarning(
            code: AssistantBusinessWarning.missingReference,
            message: 'clientReference ausente.',
          ),
        ],
      );
    }
    final ref = QuoteReference(
      id: 'quote-stub-for-${client.id}',
      label: 'Orçamento stub',
    );
    return AssistantBusinessResult(
      requestId: request.requestId,
      operation: request.operation,
      status: AssistantBusinessStatus.succeeded,
      reference: ref,
      clientReference: client,
      quoteReference: ref,
      message: 'Orçamento criado (stub).',
      warnings: const [
        AssistantBusinessWarning(
          code: AssistantBusinessWarning.stubOnly,
          message: 'Resultado stub — sem escrita no ERP.',
        ),
      ],
    );
  }
}

class _StubFindEventHandler implements AssistantBusinessOperationHandler {
  @override
  Future<AssistantBusinessResult> handle(AssistantBusinessRequest request) async {
    final query = request.params['query']?.trim() ?? 'default';
    final ref = EventReference(
      id: 'event-stub-$query',
      label: 'Evento stub',
    );
    return AssistantBusinessResult(
      requestId: request.requestId,
      operation: request.operation,
      status: AssistantBusinessStatus.succeeded,
      reference: ref,
      eventReference: ref,
      message: 'Evento localizado (stub).',
      warnings: const [
        AssistantBusinessWarning(
          code: AssistantBusinessWarning.stubOnly,
          message: 'Resultado stub — sem acesso a ERP.',
        ),
      ],
    );
  }
}

class _StubOpenEventHandler implements AssistantBusinessOperationHandler {
  @override
  Future<AssistantBusinessResult> handle(AssistantBusinessRequest request) async {
    final event = request.eventReference;
    if (event == null) {
      return AssistantBusinessResult(
        requestId: request.requestId,
        operation: request.operation,
        status: AssistantBusinessStatus.rejected,
        valid: false,
        message: 'OPEN_EVENT requer eventReference.',
        warnings: const [
          AssistantBusinessWarning(
            code: AssistantBusinessWarning.missingReference,
            message: 'eventReference ausente.',
          ),
        ],
      );
    }
    return AssistantBusinessResult(
      requestId: request.requestId,
      operation: request.operation,
      status: AssistantBusinessStatus.succeeded,
      reference: event,
      eventReference: event,
      message: 'Evento aberto (stub).',
      outputs: const {'opened': true},
      warnings: const [
        AssistantBusinessWarning(
          code: AssistantBusinessWarning.stubOnly,
          message: 'Resultado stub — sem navegação real.',
        ),
      ],
    );
  }
}

class _StubFindQuoteHandler implements AssistantBusinessOperationHandler {
  @override
  Future<AssistantBusinessResult> handle(AssistantBusinessRequest request) async {
    final query = request.params['query']?.trim() ?? 'default';
    final ref = QuoteReference(
      id: 'quote-stub-$query',
      label: 'Orçamento stub',
    );
    return AssistantBusinessResult(
      requestId: request.requestId,
      operation: request.operation,
      status: AssistantBusinessStatus.succeeded,
      reference: ref,
      quoteReference: ref,
      message: 'Orçamento localizado (stub).',
      warnings: const [
        AssistantBusinessWarning(
          code: AssistantBusinessWarning.stubOnly,
          message: 'Resultado stub — sem acesso a ERP.',
        ),
      ],
    );
  }
}

class _StubFindContractHandler implements AssistantBusinessOperationHandler {
  @override
  Future<AssistantBusinessResult> handle(AssistantBusinessRequest request) async {
    final quote = request.quoteReference;
    final idSuffix = quote?.id ?? request.params['query']?.trim() ?? 'default';
    final ref = ContractReference(
      id: 'contract-stub-$idSuffix',
      label: 'Contrato stub',
    );
    return AssistantBusinessResult(
      requestId: request.requestId,
      operation: request.operation,
      status: AssistantBusinessStatus.succeeded,
      reference: ref,
      quoteReference: quote,
      contractReference: ref,
      message: 'Contrato localizado (stub).',
      warnings: const [
        AssistantBusinessWarning(
          code: AssistantBusinessWarning.stubOnly,
          message: 'Resultado stub — sem acesso a ERP.',
        ),
      ],
    );
  }
}

/// Map-based business registry — operations registered without a giant switch.
class LocalAssistantBusinessRegistry implements AssistantBusinessRegistry {
  LocalAssistantBusinessRegistry([
    Map<String, _Entry>? entries,
  ]) : _entries = Map.unmodifiable(entries ?? const {});

  final Map<String, _Entry> _entries;

  factory LocalAssistantBusinessRegistry.defaults() {
    return LocalAssistantBusinessRegistry({
      AssistantBusinessOperationCodes.findClient: _Entry(
        const AssistantBusinessOperation(
          code: AssistantBusinessOperationCodes.findClient,
          label: 'Buscar cliente',
        ),
        _StubFindClientHandler(),
      ),
      AssistantBusinessOperationCodes.createQuote: _Entry(
        const AssistantBusinessOperation(
          code: AssistantBusinessOperationCodes.createQuote,
          label: 'Criar orçamento',
        ),
        _StubCreateQuoteHandler(),
      ),
      AssistantBusinessOperationCodes.openEvent: _Entry(
        const AssistantBusinessOperation(
          code: AssistantBusinessOperationCodes.openEvent,
          label: 'Abrir evento',
        ),
        _StubOpenEventHandler(),
      ),
      AssistantBusinessOperationCodes.findEvent: _Entry(
        const AssistantBusinessOperation(
          code: AssistantBusinessOperationCodes.findEvent,
          label: 'Buscar evento',
        ),
        _StubFindEventHandler(),
      ),
      AssistantBusinessOperationCodes.findQuote: _Entry(
        const AssistantBusinessOperation(
          code: AssistantBusinessOperationCodes.findQuote,
          label: 'Buscar orçamento',
        ),
        _StubFindQuoteHandler(),
      ),
      AssistantBusinessOperationCodes.findContract: _Entry(
        const AssistantBusinessOperation(
          code: AssistantBusinessOperationCodes.findContract,
          label: 'Buscar contrato',
        ),
        _StubFindContractHandler(),
      ),
    });
  }

  LocalAssistantBusinessRegistry register({
    required AssistantBusinessOperation operation,
    required AssistantBusinessOperationHandler handler,
  }) {
    return LocalAssistantBusinessRegistry({
      ..._entries,
      operation.code: _Entry(operation, handler),
    });
  }

  @override
  AssistantBusinessOperation? find(String code) => _entries[code]?.operation;

  @override
  AssistantBusinessOperationHandler? handlerFor(String code) =>
      _entries[code]?.handler;

  @override
  bool contains(String code) => _entries.containsKey(code);

  @override
  Iterable<AssistantBusinessOperation> get operations =>
      _entries.values.map((e) => e.operation);
}

class _Entry {
  const _Entry(this.operation, this.handler);
  final AssistantBusinessOperation operation;
  final AssistantBusinessOperationHandler handler;
}
