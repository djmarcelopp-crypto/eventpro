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
}

final class RunWorkflowIntent extends AssistantWorkflowIntent {
  const RunWorkflowIntent(this.recipe);

  final AssistantWorkflowRecipe recipe;
}
