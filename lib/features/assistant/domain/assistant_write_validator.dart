import '../models/assistant_write_request.dart';
import '../models/assistant_write_validation_result.dart';

/// Validates write intents without consulting the ERP.
abstract class AssistantWriteValidator {
  AssistantWriteValidationResult validate(AssistantWriteRequest request);
}
