import '../../models/assistant_module_request.dart';
import '../../models/assistant_module_response.dart';

/// Read-only agenda / availability contract.
abstract class AgendaGateway {
  AssistantModuleResponse checkSchedule(AssistantModuleRequest request);

  AssistantModuleResponse checkAvailability(AssistantModuleRequest request);
}
