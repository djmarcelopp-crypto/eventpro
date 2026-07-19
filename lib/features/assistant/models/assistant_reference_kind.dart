/// Deterministic reference kinds resolved from follow-up utterances.
enum AssistantReferenceKind {
  none,
  thisOne,
  last,
  previous,
  next,
  nextPage,
  ordinal,
  details,
  client,
  filterRefine,
}
