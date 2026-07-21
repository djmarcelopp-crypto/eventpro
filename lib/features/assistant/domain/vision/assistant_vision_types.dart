/// Vision input kinds (AI-026 CP-2) — references only, never bytes.
enum AssistantVisionInputType {
  image,
  document,
  pdf,
  receipt,
  contract,
  quote,
  technicalRider,
  equipmentPhoto,
  stagePhoto,
  venuePhoto,
  barcode,
  qrCode,
  unknown,
}

/// Declared vision engine capabilities.
enum AssistantVisionCapability {
  ocr,
  documentAnalysis,
  entityDetection,
  issueDetection,
  barcode,
  qrCode,
  layout,
  signatureDetection,
}

/// Confidence band for vision facts (not business decisions).
enum AssistantVisionConfidence {
  high,
  medium,
  low,
  unknown,
}

/// Standardized vision error codes (AI-026 CP-13).
enum AssistantVisionErrorCode {
  unsupportedInput,
  unsupportedCapability,
  invalidReference,
  contentUnavailable,
  analysisFailed,
  privacyRestricted,
  timeout,
  unknown,
}

/// Privacy / sensitivity categories (AI-026 CP-11).
enum AssistantVisionSensitivity {
  public,
  internal,
  confidential,
  financial,
  personalData,
  contractual,
  unknown,
}

extension AssistantVisionEnumMaps on Enum {
  Map<String, Object?> toDeterministicNameMap(String key) => {key: name};
}
