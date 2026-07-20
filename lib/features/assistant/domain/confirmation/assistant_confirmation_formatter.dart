import '../../models/assistant_confirmation_presentation.dart';
import '../../models/assistant_confirmation_result.dart';

/// Formats confirmation results into NL + structured payload.
abstract class AssistantConfirmationFormatter {
  AssistantConfirmationPresentation format(AssistantConfirmationResult result);
}
