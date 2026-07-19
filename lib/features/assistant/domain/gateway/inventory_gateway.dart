import '../../models/assistant_module_request.dart';
import '../../models/assistant_module_response.dart';

/// Read-only inventory search contract.
abstract class InventoryGateway {
  AssistantModuleResponse searchInventory(AssistantModuleRequest request);
}
