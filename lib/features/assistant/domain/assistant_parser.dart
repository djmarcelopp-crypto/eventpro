import '../models/assistant_parse_result.dart';
import '../models/assistant_request.dart';

/// Extracts entities and parse issues from natural language.
///
/// Implementations must be local and deterministic (no HTTP / LLM).
abstract class AssistantParser {
  AssistantParseResult parse(AssistantRequest request);
}
