import '../../models/assistant_module_request.dart';
import '../../models/assistant_module_response.dart';

/// Read-only quote lookup contract.
abstract class QuoteGateway {
  AssistantModuleResponse lookupQuote(AssistantModuleRequest request);
}
