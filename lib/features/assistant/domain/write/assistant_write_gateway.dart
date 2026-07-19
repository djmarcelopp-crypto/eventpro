import '../../models/assistant_write_adapter_result.dart';
import 'assistant_write_adapter.dart';
import 'assistant_write_transaction.dart';

/// Facade that routes a prepared write transaction to a registered adapter.
///
/// The assistant never reaches repositories through this contract.
abstract class AssistantWriteGateway {
  AssistantWriteAdapter? get quoteDraftAdapter;

  bool get isAvailable;

  Future<AssistantWriteAdapterResult> execute(
    AssistantWriteTransaction transaction,
  );
}
