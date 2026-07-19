import '../../models/assistant_read_query.dart';
import '../../models/assistant_read_result.dart';

/// Hexagonal port: interprets a generic [AssistantReadQuery] for one module.
abstract class AssistantReadAdapter {
  String get name;

  String get module;

  bool supports(AssistantReadQuery query);

  Future<AssistantReadResult> execute(AssistantReadQuery query);
}
