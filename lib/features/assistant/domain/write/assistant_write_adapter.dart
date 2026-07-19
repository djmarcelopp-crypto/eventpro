import '../../models/assistant_write_adapter_result.dart';
import 'assistant_write_transaction.dart';

/// Hexagonal port for a module-specific write adapter.
///
/// Implementations live in ERP modules (or tests) and must not be imported
/// as repositories/DAOs by the assistant core.
abstract class AssistantWriteAdapter {
  String get name;

  bool supports(AssistantWriteTransaction transaction);

  Future<AssistantWriteAdapterResult> execute(
    AssistantWriteTransaction transaction,
  );
}
