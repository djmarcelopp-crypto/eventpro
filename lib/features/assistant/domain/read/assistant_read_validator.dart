import '../../models/assistant_read_query.dart';
import '../../models/assistant_read_validation_result.dart';

/// Validates structured read queries without touching the ERP.
abstract class AssistantReadValidator {
  AssistantReadValidationResult validate(AssistantReadQuery query);
}
