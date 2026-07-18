import '../models/assistant_intent.dart';
import '../models/assistant_parse_result.dart';
import '../models/assistant_request.dart';

/// Classifies primary and alternative intents from text + parse result.
abstract class AssistantIntentClassifier {
  /// Returns intents ordered by confidence (primary first).
  List<AssistantIntent> classify({
    required AssistantRequest request,
    required AssistantParseResult parseResult,
  });
}
