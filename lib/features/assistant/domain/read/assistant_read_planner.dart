import '../../models/assistant_read_intent.dart';
import '../../models/assistant_read_query.dart';

/// Maps a deterministic read intent into an [AssistantReadQuery].
abstract class AssistantReadPlanner {
  AssistantReadQuery plan(
    AssistantReadIntent intent, {
    required String requestId,
    String? queryId,
  });
}
