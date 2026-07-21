/// Tool categories (AI-028).
enum AssistantToolCategory {
  lookup,
  read,
  write,
  workflow,
  reminder,
  system,
  unknown,
}

/// Declared tool capabilities.
enum AssistantToolCapability {
  findCustomer,
  findEvent,
  findQuote,
  findContract,
  findSupplier,
  createReminder,
  openWorkflow,
  describe,
  validate,
}

/// Permission classes (AI-028 CP-8).
enum AssistantToolPermission {
  read,
  write,
  admin,
  system,
  dangerous,
}

/// Scope of a tool invocation.
enum AssistantToolScope {
  session,
  user,
  company,
  global,
  system,
}

/// Risk level declared by a tool.
enum AssistantToolRisk {
  low,
  medium,
  high,
  critical,
}

/// Execution lifecycle status.
enum AssistantToolExecutionStatus {
  pending,
  validating,
  running,
  succeeded,
  failed,
  denied,
  skipped,
}

/// Standardized tool error codes.
enum AssistantToolErrorCode {
  unknownTool,
  unsupportedCapability,
  invalidParameters,
  validationFailed,
  permissionDenied,
  executionFailed,
  timeout,
  unknown,
}
