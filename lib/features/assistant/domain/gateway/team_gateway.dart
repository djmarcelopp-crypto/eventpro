import '../../models/assistant_module_request.dart';
import '../../models/assistant_module_response.dart';

/// Read-only team search contract.
abstract class TeamGateway {
  AssistantModuleResponse searchTeam(AssistantModuleRequest request);
}
