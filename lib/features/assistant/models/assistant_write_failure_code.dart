/// Structured failure codes for the controlled write pipeline.
enum AssistantWriteFailureCode {
  validationDenied,
  authorizationDenied,
  confirmationRequired,
  confirmationInvalid,
  unsupportedOperation,
  unsupportedTarget,
  invalidDraftState,
  adapterUnavailable,
  serviceFailure,
  timeout,
  rollbackFailure,
  duplicateOperation,
  uncertainOutcome,
  missingIdempotencyKey,
  productionNotAllowed,
}
