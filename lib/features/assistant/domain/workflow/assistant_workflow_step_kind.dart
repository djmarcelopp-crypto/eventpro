/// Kinds of reusable pipeline steps a workflow may invoke.
enum AssistantWorkflowStepKind {
  read,
  insight,
  action,
  confirmation,
  transactionExecution,
  audit,
  business,
}
