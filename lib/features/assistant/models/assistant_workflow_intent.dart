/// Resolved multi-step workflow intent.
sealed class AssistantWorkflowIntent {
  const AssistantWorkflowIntent();
}

/// Named deterministic recipes composed of existing pipelines.
enum AssistantWorkflowRecipe {
  /// confirmation status → audit history
  confirmationStatusThenAudit,

  /// confirmation create → audit history
  confirmationCreateThenAudit,

  /// insight (last quote) → action (open last quote)
  reviewQuotesThenOpenLast,

  /// FIND_CLIENT → CREATE_QUOTE (business stubs)
  findClientThenCreateQuote,

  /// FIND_EVENT → OPEN_EVENT (business stubs)
  findEventThenOpenEvent,

  /// FIND_QUOTE → FIND_CONTRACT (business stubs)
  findQuoteThenFindContract,
}

final class RunWorkflowIntent extends AssistantWorkflowIntent {
  const RunWorkflowIntent(this.recipe);

  final AssistantWorkflowRecipe recipe;
}
