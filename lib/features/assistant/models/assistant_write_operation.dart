/// Intended write operation kind for a future safe-write pipeline.
///
/// AI-005 models intent only — never performs ERP mutations.
enum AssistantWriteOperation {
  create,
  update,

  /// Reserved — not enabled in AI-005.
  delete,

  /// Reserved — not enabled in AI-005.
  cancel,
}
