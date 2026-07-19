import '../../models/assistant_action_presentation.dart';
import '../../models/assistant_action_result.dart';

/// Formats smart-action results into NL + structured payload.
abstract class AssistantActionFormatter {
  AssistantActionPresentation format(AssistantActionResult result);
}
