import '../models/assistant_execution_plan.dart';
import '../models/assistant_response.dart';

/// Builds an explicit [AssistantExecutionPlan] from an interpreted response.
///
/// Never executes ERP operations — planning only.
abstract class AssistantExecutionPlanner {
  AssistantExecutionPlan plan(AssistantResponse response);
}
