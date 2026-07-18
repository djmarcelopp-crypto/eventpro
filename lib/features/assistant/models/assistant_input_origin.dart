/// Origin of an [AssistantRequest] input channel.
///
/// Only [typedText] and [pastedText] are used in AI-001. Remaining values
/// reserve the contract for future multimodal intake.
enum AssistantInputOrigin {
  typedText,
  pastedText,
  audioTranscript,
  imageDescription,
  documentText,
  whatsappConversation,
  emailText,
}
