import '../../models/assistant_action_request.dart';
import '../../models/assistant_action_result.dart';

/// Executes a planned smart action (navigation directive only).
abstract class AssistantActionAdapter {
  String get name;

  bool supports(AssistantActionRequest request);

  Future<AssistantActionResult> execute(AssistantActionRequest request);
}
