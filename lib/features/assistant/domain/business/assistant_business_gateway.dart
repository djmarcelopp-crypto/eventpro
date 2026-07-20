import 'assistant_business_request.dart';
import 'assistant_business_result.dart';

/// Port for invoking business operations without ERP coupling.
abstract class AssistantBusinessGateway {
  Future<AssistantBusinessResult> execute(AssistantBusinessRequest request);
}
