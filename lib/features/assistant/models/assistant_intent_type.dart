/// High-level user intent recognized by the Assistente EventPRO.
///
/// AI-001 only interprets intents — it never executes ERP side effects.
enum AssistantIntentType {
  createEvent,
  createQuote,
  checkSchedule,
  checkAvailability,
  searchClient,
  updateEvent,
  unknown,
}
