import '../domain/write/assistant_write_adapter.dart';
import '../domain/write/assistant_write_gateway.dart';
import '../domain/write/assistant_write_transaction.dart';
import '../models/assistant_write_adapter_result.dart';
import '../models/assistant_write_failure.dart';
import '../models/assistant_write_failure_code.dart';

/// Local write gateway — routes to a registered quote-draft adapter only.
class LocalAssistantWriteGateway implements AssistantWriteGateway {
  const LocalAssistantWriteGateway({
    AssistantWriteAdapter? quoteDraftAdapter,
  }) : _quoteDraftAdapter = quoteDraftAdapter;

  final AssistantWriteAdapter? _quoteDraftAdapter;

  @override
  AssistantWriteAdapter? get quoteDraftAdapter => _quoteDraftAdapter;

  @override
  bool get isAvailable =>
      _quoteDraftAdapter != null;

  @override
  Future<AssistantWriteAdapterResult> execute(
    AssistantWriteTransaction transaction,
  ) async {
    final adapter = _quoteDraftAdapter;
    if (adapter == null) {
      return AssistantWriteAdapterResult.skipped(
        summary: 'Adapter de escrita indisponível',
        failure: const AssistantWriteFailure(
          code: AssistantWriteFailureCode.adapterUnavailable,
          message: 'Nenhum Quote Write Adapter registrado',
        ),
      );
    }
    if (!adapter.supports(transaction)) {
      return AssistantWriteAdapterResult.skipped(
        summary: 'Adapter não suporta a transação',
        failure: const AssistantWriteFailure(
          code: AssistantWriteFailureCode.unsupportedOperation,
          message: 'Transação rejeitada pelo adapter registrado',
        ),
      );
    }
    return adapter.execute(
      transaction.copyWith(adapterName: adapter.name),
    );
  }
}
