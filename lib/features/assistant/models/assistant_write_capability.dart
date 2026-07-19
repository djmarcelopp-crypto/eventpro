/// Declared write capabilities the assistant may *intend* (never executes here).
///
/// Orthogonal to read capabilities (`canExecuteClientSearch`, etc.).
enum AssistantWriteCapability {
  createEvent,
  createQuote,
  updateEvent,
  updateQuote,
  createClient,

  /// Reserved.
  deleteEvent,

  /// Reserved.
  cancelEvent,
}
