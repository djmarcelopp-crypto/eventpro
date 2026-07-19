import '../domain/assistant_write_authorizer.dart';
import '../models/assistant_write_authorization_status.dart';
import '../models/assistant_write_request.dart';

/// Local, deterministic write authorizer — evaluate only, never mutate.
class LocalAssistantWriteAuthorizer implements AssistantWriteAuthorizer {
  const LocalAssistantWriteAuthorizer();

  @override
  AssistantWriteAuthorizationStatus authorize(AssistantWriteRequest request) {
    if (request.isReservedOperation) {
      return AssistantWriteAuthorizationStatus.denied;
    }

    final authorization = request.authorization;
    if (authorization == null) {
      return AssistantWriteAuthorizationStatus.denied;
    }

    if (!authorization.granted) {
      return AssistantWriteAuthorizationStatus.denied;
    }

    if (!authorization.allowedCapabilities.contains(request.capability)) {
      return AssistantWriteAuthorizationStatus.insufficientPrivileges;
    }

    if (authorization.requiresUserConfirmation) {
      return AssistantWriteAuthorizationStatus.confirmationRequired;
    }

    return AssistantWriteAuthorizationStatus.authorized;
  }
}
