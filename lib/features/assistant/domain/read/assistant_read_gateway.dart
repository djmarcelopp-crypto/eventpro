import '../../models/assistant_read_query.dart';
import '../../models/assistant_read_result.dart';
import 'assistant_read_adapter.dart';

/// Read-only gateway — never mutates the ERP.
abstract class AssistantReadGateway {
  AssistantReadAdapter? adapterFor(String module);

  bool get isAvailable;

  Future<AssistantReadResult> execute(AssistantReadQuery query);
}
