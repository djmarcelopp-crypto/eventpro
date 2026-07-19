import '../models/assistant_write_authorization_status.dart';
import '../models/assistant_write_request.dart';

/// Evaluates write-intent authorization only — never executes or persists.
abstract class AssistantWriteAuthorizer {
  AssistantWriteAuthorizationStatus authorize(AssistantWriteRequest request);
}
