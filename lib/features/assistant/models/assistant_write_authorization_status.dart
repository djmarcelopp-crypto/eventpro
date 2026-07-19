/// Outcome of evaluating write-intent authorization (never executes).
enum AssistantWriteAuthorizationStatus {
  authorized,
  denied,
  insufficientPrivileges,
  confirmationRequired,
}
