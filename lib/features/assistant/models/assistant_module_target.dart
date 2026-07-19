/// Logical ERP module targeted by a planned step.
///
/// The planner never imports or calls these modules — labels only.
enum AssistantModuleTarget {
  events,
  quotes,
  agenda,
  inventory,
  finance,
  clients,
  none,
}
