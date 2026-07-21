enum AssistantDocumentType {
  contract,
  quote,
  invoice,
  receipt,
  equipmentList,
  technicalRider,
  eventBriefing,
  purchaseOrder,
  unknown,
}

class AssistantDocumentField {
  const AssistantDocumentField({
    required this.name,
    required this.value,
    this.confidence,
  });

  final String name;
  final String value;
  final double? confidence;

  Map<String, Object?> toDeterministicMap() => {
        'name': name,
        'value': value,
        'confidence': confidence,
      };
}

class AssistantDocumentTable {
  const AssistantDocumentTable({
    required this.id,
    this.headers = const [],
    this.rows = const [],
  });

  final String id;
  final List<String> headers;
  final List<List<String>> rows;

  Map<String, Object?> toDeterministicMap() => {
        'id': id,
        'headers': headers,
        'rows': rows,
      };
}

class AssistantDocumentSignature {
  const AssistantDocumentSignature({
    required this.detected,
    this.label,
    this.confidence,
  });

  final bool detected;
  final String? label;
  final double? confidence;

  Map<String, Object?> toDeterministicMap() => {
        'detected': detected,
        'label': label,
        'confidence': confidence,
      };
}

class AssistantDocumentAnalysisRequest {
  const AssistantDocumentAnalysisRequest({
    required this.referenceUri,
    this.fileName,
    this.mimeType,
    this.hintType,
    this.correlationId,
  });

  final String referenceUri;
  final String? fileName;
  final String? mimeType;
  final AssistantDocumentType? hintType;
  final String? correlationId;

  Map<String, Object?> toDeterministicMap() => {
        'referenceUri': referenceUri,
        'fileName': fileName,
        'mimeType': mimeType,
        'hintType': hintType?.name,
        'correlationId': correlationId,
      };
}

class AssistantDocumentAnalysisResult {
  const AssistantDocumentAnalysisResult({
    required this.documentType,
    this.fields = const [],
    this.tables = const [],
    this.signatures = const [],
    this.confidence,
    this.summary,
  });

  final AssistantDocumentType documentType;
  final List<AssistantDocumentField> fields;
  final List<AssistantDocumentTable> tables;
  final List<AssistantDocumentSignature> signatures;
  final double? confidence;
  final String? summary;

  static const unknown = AssistantDocumentAnalysisResult(
    documentType: AssistantDocumentType.unknown,
    confidence: 0.2,
  );

  Map<String, Object?> toDeterministicMap() => {
        'documentType': documentType.name,
        'fields': fields.map((f) => f.toDeterministicMap()).toList(),
        'tables': tables.map((t) => t.toDeterministicMap()).toList(),
        'signatures': signatures.map((s) => s.toDeterministicMap()).toList(),
        'confidence': confidence,
        'summary': summary,
      };
}
