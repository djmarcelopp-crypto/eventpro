/// Outcome of normalizing an [AssistantInput] (never runs OCR/STT/vision).
enum AssistantInputNormalizationStatus {
  /// Text (or equivalent) ready for interpretation.
  ready,

  /// Input failed validation.
  invalid,

  /// Modality or mime not supported by the architecture yet.
  unsupported,

  /// Valid attachment; specialized processor required.
  requiresProcessing,

  /// Unexpected failure during normalization.
  failed,
}

extension AssistantInputNormalizationStatusX
    on AssistantInputNormalizationStatus {
  bool get isReady => this == AssistantInputNormalizationStatus.ready;

  bool get blocksInterpretation =>
      this != AssistantInputNormalizationStatus.ready;

  Map<String, Object?> toDeterministicMap() => {'status': name};
}
