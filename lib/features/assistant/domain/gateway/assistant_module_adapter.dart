import '../../models/assistant_module_availability.dart';
import '../../models/assistant_module_capability.dart';
import '../../models/assistant_module_request.dart';
import '../../models/assistant_module_response.dart';

/// Contract for a read-only module adapter.
///
/// Implementations must not import repositories, DAOs, or concrete ERP services.
abstract class AssistantModuleAdapter {
  AssistantModuleCapability get capability;

  AssistantModuleAvailability get availability;

  AssistantModuleResponse handle(AssistantModuleRequest request);
}
