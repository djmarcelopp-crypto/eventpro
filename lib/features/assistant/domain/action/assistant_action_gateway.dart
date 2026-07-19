import '../../models/assistant_action_request.dart';
import '../../models/assistant_action_result.dart';
import 'assistant_action_adapter.dart';

/// Routes smart-action requests to a local adapter.
abstract class AssistantActionGateway {
  bool get isAvailable;

  AssistantActionAdapter? get adapter;

  Future<AssistantActionResult> execute(AssistantActionRequest request);
}
