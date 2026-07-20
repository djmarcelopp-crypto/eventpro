/// Sensitive operation kinds that may require safe confirmation.
///
/// AI-013 only plans/previews — never executes these operations.
enum AssistantConfirmationOperationKind {
  createQuoteDraft,
  genericSensitive,
}
