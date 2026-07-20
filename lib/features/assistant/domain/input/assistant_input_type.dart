/// Modality of an [AssistantInput].
enum AssistantInputType {
  text,
  image,
  audio,
  document,
}

extension AssistantInputTypeX on AssistantInputType {
  Map<String, Object?> toDeterministicMap() => {'type': name};
}
