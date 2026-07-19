import '../../models/assistant_module_request.dart';
import '../../models/assistant_module_response.dart';

/// Read-only client lookup contract.
abstract class ClientGateway {
  AssistantModuleResponse searchClient(AssistantModuleRequest request);
}
