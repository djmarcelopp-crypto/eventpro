import '../../models/assistant_read_intent.dart';
import '../../models/assistant_read_presentation.dart';
import '../../models/assistant_read_result.dart';

/// Formats a structured read result into NL + structured payload.
abstract class AssistantReadFormatter {
  AssistantReadPresentation format({
    required AssistantReadResult result,
    AssistantReadIntent? intent,
  });
}
