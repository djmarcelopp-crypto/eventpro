/// Channel / origin of an [AssistantInput].
enum AssistantInputSource {
  typedText,
  pastedText,
  filePicker,
  camera,
  microphone,
  whatsapp,
  email,
  api,
  unknown,
}

extension AssistantInputSourceX on AssistantInputSource {
  Map<String, Object?> toDeterministicMap() => {'source': name};
}
