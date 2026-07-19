/// Requested / resulting persistence state for a write intent.
///
/// AI-006/AI-007 only allow [draft] for real writes. Other values exist so
/// policies can explicitly deny non-draft production requests.
enum AssistantWriteEntityState {
  draft,

  /// Reserved — production blocked.
  sent,

  /// Reserved — production blocked.
  approved,

  /// Reserved — production blocked.
  cancelled,
}
