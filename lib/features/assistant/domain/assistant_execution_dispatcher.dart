import '../models/assistant_execution_report.dart';
import '../models/assistant_execution_request.dart';

/// Runs Validator → Confirmation → Dry-run report.
///
/// Never calls ERP modules or gateways.
abstract class AssistantExecutionDispatcher {
  AssistantExecutionReport dispatch(AssistantExecutionRequest request);
}
