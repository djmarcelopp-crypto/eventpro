/// Read-only module operations exposed through assistant gateways.
///
/// AI-003 never includes write/create/update/delete capabilities here.
enum AssistantModuleCapability {
  searchClient,
  checkSchedule,
  checkAvailability,
  lookupQuote,
  searchInventory,
  searchTeam,
}
