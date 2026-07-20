import 'assistant_business_operation.dart';
import 'assistant_business_request.dart';
import 'assistant_business_result.dart';

/// Executes one registered business operation (no ERP rules in the engine).
abstract class AssistantBusinessOperationHandler {
  Future<AssistantBusinessResult> handle(AssistantBusinessRequest request);
}

/// Extensible catalog of business operations — no giant switch.
abstract class AssistantBusinessRegistry {
  AssistantBusinessOperation? find(String code);

  AssistantBusinessOperationHandler? handlerFor(String code);

  bool contains(String code) => find(code) != null;

  Iterable<AssistantBusinessOperation> get operations;
}
