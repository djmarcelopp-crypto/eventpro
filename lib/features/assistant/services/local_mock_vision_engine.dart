import '../domain/vision/assistant_document_analysis.dart';
import '../domain/vision/assistant_ocr.dart';
import '../domain/vision/assistant_vision_core.dart';
import '../domain/vision/assistant_vision_port.dart';
import '../domain/vision/assistant_vision_result.dart';
import '../domain/vision/assistant_vision_types.dart';
import '../domain/vision/assistant_visual_analysis.dart';

/// Deterministic mock Vision Engine (AI-026 CP-7).
///
/// No IA, OCR, HTTP, SDKs, or real file reads — keyword rules on references.
class LocalMockVisionEngine implements AssistantVisionPort {
  LocalMockVisionEngine({
    this.engineId = defaultEngineId,
    AssistantVisionObserver? observer,
    DateTime Function()? clock,
  })  : _observer = observer ?? const NoopAssistantVisionObserver(),
        _clock = clock ?? DateTime.now;

  static const defaultEngineId = 'local.mock.vision';

  @override
  final String engineId;

  final AssistantVisionObserver _observer;
  final DateTime Function() _clock;

  static const _caps = {
    AssistantVisionCapability.ocr,
    AssistantVisionCapability.documentAnalysis,
    AssistantVisionCapability.entityDetection,
    AssistantVisionCapability.issueDetection,
    AssistantVisionCapability.barcode,
    AssistantVisionCapability.qrCode,
    AssistantVisionCapability.signatureDetection,
  };

  @override
  Set<AssistantVisionCapability> get capabilities => _caps;

  static AssistantVisionEngineRegistration registration({
    LocalMockVisionEngine? port,
    int priority = 0,
  }) {
    final engine = port ?? LocalMockVisionEngine();
    return AssistantVisionEngineRegistration(
      engineId: engine.engineId,
      port: engine,
      priority: priority,
      supportedInputTypes: AssistantVisionInputType.values.toSet(),
      supportedMimePrefixes: const [
        'image/',
        'application/pdf',
        'application/octet-stream',
      ],
    );
  }

  @override
  bool supports(AssistantVisionCapability capability) =>
      _caps.contains(capability);

  @override
  Future<AssistantVisionHealth> health() async {
    return AssistantVisionHealth(
      status: AssistantVisionHealthStatus.healthy,
      checkedAt: _clock().toUtc(),
      message: 'local.mock.vision ready',
    );
  }

  @override
  Future<AssistantVisionResult> analyze(AssistantVisionRequest request) async {
    final started = _clock().toUtc();
    if (!request.input.reference.isValid) {
      return _fail(
        request,
        started,
        const AssistantVisionError(
          code: AssistantVisionErrorCode.invalidReference,
          message: 'Vision reference is empty',
        ),
      );
    }

    if (request.privacy.sensitivity == AssistantVisionSensitivity.personalData &&
        request.privacy.redacted) {
      return AssistantVisionResult(
        engineId: engineId,
        analyzedAt: started,
        status: AssistantVisionResultStatus.restricted,
        confidence: AssistantVisionConfidence.low,
        privacy: request.privacy,
        error: const AssistantVisionError(
          code: AssistantVisionErrorCode.privacyRestricted,
          message: 'Analysis restricted by privacy metadata',
        ),
      );
    }

    final label = _normalize(request.input.reference.label);
    final ocr = await extractText(
      AssistantOcrRequest(
        referenceUri: request.input.reference.uri,
        fileName: request.input.reference.fileName,
        mimeType: request.input.reference.mimeType,
        languageHint: request.input.locale ?? request.metadata.locale,
        correlationId: request.metadata.correlationId,
      ),
    );
    final document = await analyzeDocument(
      AssistantDocumentAnalysisRequest(
        referenceUri: request.input.reference.uri,
        fileName: request.input.reference.fileName,
        mimeType: request.input.reference.mimeType,
        correlationId: request.metadata.correlationId,
      ),
    );
    final entities = await detectEntities(request);
    final issues = await detectIssues(request);
    final signals = _buildSignals(label, document, entities);
    final confidence = _confidenceFor(label, document, entities);
    final privacy = _inferPrivacy(label, document);

    final result = AssistantVisionResult(
      engineId: engineId,
      analyzedAt: started,
      confidence: confidence,
      ocr: ocr,
      document: document,
      entities: entities,
      issues: issues,
      signals: signals,
      privacy: privacy,
      status: AssistantVisionResultStatus.ok,
      annotations: [
        for (final s in signals)
          AssistantVisualAnnotation(
            code: s.code,
            message: s.message,
            confidence: s.confidence,
          ),
      ],
      suggestions: [
        if (document.documentType == AssistantDocumentType.contract)
          const AssistantVisualSuggestion(
            code: 'review_contract_fields',
            message: 'Revisar campos do contrato antes de qualquer ação',
          ),
      ],
    );

    _observe(
      operation: 'analyze',
      request: request,
      result: result,
      started: started,
    );
    return result;
  }

  @override
  Future<AssistantOcrResult> extractText(AssistantOcrRequest request) async {
    final label = _normalize(request.fileName ?? request.referenceUri);
    if (label.isEmpty) {
      return AssistantOcrResult.empty;
    }

    // Deterministic stub text — not real OCR.
    final stub = 'mock-ocr:$label';
    final page = AssistantOcrPage(
      pageNumber: 1,
      text: stub,
      language: request.languageHint ?? 'pt',
      confidence: 0.55,
      blocks: [
        AssistantOcrBlock(
          text: stub,
          confidence: 0.55,
          lines: [
            AssistantOcrLine(
              text: stub,
              confidence: 0.55,
              words: [
                for (final w in stub.split(RegExp(r'[:\s]+')))
                  if (w.isNotEmpty) AssistantOcrWord(text: w, confidence: 0.55),
              ],
            ),
          ],
        ),
      ],
    );
    return AssistantOcrResult(
      pages: [page],
      fullText: stub,
      language: page.language,
      confidence: 0.55,
      characterCount: stub.length,
    );
  }

  @override
  Future<AssistantDocumentAnalysisResult> analyzeDocument(
    AssistantDocumentAnalysisRequest request,
  ) async {
    final label = _normalize(request.fileName ?? request.referenceUri);
    final type = _documentTypeFor(label);
    final signatureDetected = label.contains('contrato') ||
        label.contains('assinatura') ||
        label.contains('contract');

    return AssistantDocumentAnalysisResult(
      documentType: type,
      confidence: type == AssistantDocumentType.unknown ? 0.25 : 0.8,
      summary: type == AssistantDocumentType.unknown
          ? 'Documento não classificado pelo mock'
          : 'Documento classificado como ${type.name} (mock)',
      fields: [
        if (type != AssistantDocumentType.unknown)
          AssistantDocumentField(
            name: 'detectedType',
            value: type.name,
            confidence: 0.8,
          ),
      ],
      signatures: [
        if (signatureDetected)
          const AssistantDocumentSignature(
            detected: true,
            label: 'possible_signature_region',
            confidence: 0.6,
          ),
      ],
    );
  }

  @override
  Future<List<AssistantVisualEntity>> detectEntities(
    AssistantVisionRequest request,
  ) async {
    final label = _normalize(request.input.reference.label);
    final entities = <AssistantVisualEntity>[];
    var i = 0;

    void add(AssistantVisualEntityType type, String idSuffix) {
      entities.add(
        AssistantVisualEntity(
          id: 'ent-${++i}-$idSuffix',
          type: type,
          label: type.name,
          confidence: AssistantVisionConfidence.medium,
        ),
      );
    }

    if (label.contains('palco') || label.contains('stage')) {
      add(AssistantVisualEntityType.stage, 'stage');
      add(AssistantVisualEntityType.speaker, 'speaker');
      add(AssistantVisualEntityType.truss, 'truss');
    }
    if (label.contains('energia') || label.contains('power')) {
      add(AssistantVisualEntityType.powerDistributor, 'power');
    }
    if (label.contains('qr') || label.contains('qrcode')) {
      add(AssistantVisualEntityType.qrCode, 'qr');
    }
    if (label.contains('barcode') || label.contains('codigo-barra')) {
      add(AssistantVisualEntityType.barcode, 'barcode');
    }
    if (label.contains('equip') || label.contains('caixa')) {
      add(AssistantVisualEntityType.equipment, 'equipment');
    }
    if (_documentTypeFor(label) != AssistantDocumentType.unknown) {
      add(AssistantVisualEntityType.document, 'document');
    }

    return entities;
  }

  @override
  Future<List<AssistantVisualIssue>> detectIssues(
    AssistantVisionRequest request,
  ) async {
    final label = _normalize(request.input.reference.label);
    if (label.isEmpty) {
      return const [
        AssistantVisualIssue(
          code: 'empty_reference',
          message: 'Referência visual vazia',
          severity: 'warning',
        ),
      ];
    }
    if (_documentTypeFor(label) == AssistantDocumentType.unknown &&
        !label.contains('palco') &&
        !label.contains('energia') &&
        !label.contains('stage') &&
        !label.contains('power')) {
      return const [
        AssistantVisualIssue(
          code: 'low_confidence_unknown',
          message: 'Entrada desconhecida — baixa confiança',
          severity: 'info',
        ),
      ];
    }
    return const [];
  }

  AssistantDocumentType _documentTypeFor(String label) {
    if (label.contains('contrato') || label.contains('contract')) {
      return AssistantDocumentType.contract;
    }
    if (label.contains('orcamento') ||
        label.contains('orçamento') ||
        label.contains('quote')) {
      return AssistantDocumentType.quote;
    }
    if (label.contains('comprovante') || label.contains('receipt')) {
      return AssistantDocumentType.receipt;
    }
    if (label.contains('nota') || label.contains('invoice')) {
      return AssistantDocumentType.invoice;
    }
    if (label.contains('rider') || label.contains('tecnico')) {
      return AssistantDocumentType.technicalRider;
    }
    return AssistantDocumentType.unknown;
  }

  List<AssistantVisionSignal> _buildSignals(
    String label,
    AssistantDocumentAnalysisResult document,
    List<AssistantVisualEntity> entities,
  ) {
    final signals = <AssistantVisionSignal>[];

    if (document.documentType == AssistantDocumentType.contract) {
      signals.add(
        const AssistantVisionSignal(
          code: 'document_looks_like_contract',
          message: 'Documento parece contrato',
          confidence: AssistantVisionConfidence.high,
        ),
      );
    }
    if (document.documentType == AssistantDocumentType.quote) {
      signals.add(
        const AssistantVisionSignal(
          code: 'document_looks_like_quote',
          message: 'Documento parece orçamento',
          confidence: AssistantVisionConfidence.high,
        ),
      );
    }
    if (document.documentType == AssistantDocumentType.receipt) {
      signals.add(
        const AssistantVisionSignal(
          code: 'possible_receipt',
          message: 'Possível comprovante',
          confidence: AssistantVisionConfidence.high,
        ),
      );
    }
    if (document.signatures.any((s) => s.detected)) {
      signals.add(
        const AssistantVisionSignal(
          code: 'signature_detected',
          message: 'Assinatura detectada',
          confidence: AssistantVisionConfidence.medium,
        ),
      );
    }
    if (entities.any((e) => e.type == AssistantVisualEntityType.equipment)) {
      signals.add(
        const AssistantVisionSignal(
          code: 'equipment_identified',
          message: 'Equipamento identificado',
          confidence: AssistantVisionConfidence.medium,
        ),
      );
    }
    if (entities.any((e) => e.type == AssistantVisualEntityType.qrCode)) {
      signals.add(
        const AssistantVisionSignal(
          code: 'qr_code_present',
          message: 'QR Code presente',
          confidence: AssistantVisionConfidence.high,
        ),
      );
    }
    if (document.documentType == AssistantDocumentType.unknown &&
        entities.isEmpty) {
      signals.add(
        const AssistantVisionSignal(
          code: 'unknown_low_confidence',
          message: 'Entrada desconhecida com baixa confiança',
          confidence: AssistantVisionConfidence.low,
        ),
      );
    }
    return signals;
  }

  AssistantVisionConfidence _confidenceFor(
    String label,
    AssistantDocumentAnalysisResult document,
    List<AssistantVisualEntity> entities,
  ) {
    if (document.documentType != AssistantDocumentType.unknown) {
      return AssistantVisionConfidence.high;
    }
    if (entities.isNotEmpty) return AssistantVisionConfidence.medium;
    if (label.isEmpty) return AssistantVisionConfidence.unknown;
    return AssistantVisionConfidence.low;
  }

  AssistantVisionPrivacyMetadata _inferPrivacy(
    String label,
    AssistantDocumentAnalysisResult document,
  ) {
    if (document.documentType == AssistantDocumentType.contract) {
      return const AssistantVisionPrivacyMetadata(
        sensitivity: AssistantVisionSensitivity.contractual,
      );
    }
    if (document.documentType == AssistantDocumentType.receipt ||
        document.documentType == AssistantDocumentType.invoice) {
      return const AssistantVisionPrivacyMetadata(
        sensitivity: AssistantVisionSensitivity.financial,
        containsFinancialData: true,
      );
    }
    if (label.contains('cpf') || label.contains('rg')) {
      return const AssistantVisionPrivacyMetadata(
        sensitivity: AssistantVisionSensitivity.personalData,
        containsPersonalData: true,
      );
    }
    return const AssistantVisionPrivacyMetadata(
      sensitivity: AssistantVisionSensitivity.internal,
    );
  }

  AssistantVisionResult _fail(
    AssistantVisionRequest request,
    DateTime started,
    AssistantVisionError error,
  ) {
    final result = AssistantVisionResult(
      engineId: engineId,
      analyzedAt: started,
      status: AssistantVisionResultStatus.failed,
      confidence: AssistantVisionConfidence.unknown,
      error: error,
      privacy: request.privacy,
    );
    _observe(
      operation: 'analyze',
      request: request,
      result: result,
      started: started,
    );
    return result;
  }

  void _observe({
    required String operation,
    required AssistantVisionRequest request,
    required AssistantVisionResult result,
    required DateTime started,
  }) {
    final ended = _clock().toUtc();
    _observer.record(
      AssistantVisionObservation(
        operation: operation,
        engineId: engineId,
        timestamp: ended,
        status: result.status.name,
        confidence: result.confidence,
        entityCount: result.entities.length,
        pageCount: result.ocr.pages.length,
        characterCount: result.ocr.characterCount,
        latencyMs: ended.difference(started).inMilliseconds,
        correlationId: request.metadata.correlationId,
        errorCode: result.error?.code.name,
      ),
    );
  }

  String _normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('à', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('â', 'a')
        .replaceAll('é', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ç', 'c');
  }
}
