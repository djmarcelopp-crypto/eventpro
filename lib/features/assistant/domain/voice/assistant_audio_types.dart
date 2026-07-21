/// Audio kinds (AI-027 CP-2) — references only, never bytes.
enum AssistantAudioType {
  voice,
  meeting,
  phoneCall,
  voiceNote,
  podcast,
  music,
  ambient,
  unknown,
}

/// Declared voice engine capabilities.
enum AssistantAudioCapability {
  transcription,
  synthesis,
  languageDetection,
  speakerDetection,
  audioAnalysis,
}

/// Confidence band for audio facts (not business decisions).
enum AssistantAudioConfidence {
  high,
  medium,
  low,
  unknown,
}

/// Standardized voice/audio error codes (AI-027 CP-12).
enum AssistantAudioErrorCode {
  unsupportedAudio,
  invalidReference,
  transcriptionFailed,
  synthesisFailed,
  languageDetectionFailed,
  privacyRestricted,
  timeout,
  unknown,
}

/// Privacy / sensitivity categories (AI-027 CP-10).
enum AssistantAudioSensitivity {
  public,
  internal,
  confidential,
  personalData,
  financial,
  legal,
  unknown,
}
