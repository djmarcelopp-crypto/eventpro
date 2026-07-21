/// Axis-aligned box in normalized or pixel coordinates (OCR / annotations).
class AssistantBoundingBox {
  const AssistantBoundingBox({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final double x;
  final double y;
  final double width;
  final double height;

  Map<String, Object?> toDeterministicMap() => {
        'x': x,
        'y': y,
        'width': width,
        'height': height,
      };
}

/// OCR word token (contracts only — no real OCR).
class AssistantOcrWord {
  const AssistantOcrWord({
    required this.text,
    this.confidence,
    this.boundingBox,
  });

  final String text;
  final double? confidence;
  final AssistantBoundingBox? boundingBox;

  Map<String, Object?> toDeterministicMap() => {
        'text': text,
        'confidence': confidence,
        'boundingBox': boundingBox?.toDeterministicMap(),
      };
}

class AssistantOcrLine {
  const AssistantOcrLine({
    required this.text,
    this.words = const [],
    this.confidence,
    this.boundingBox,
  });

  final String text;
  final List<AssistantOcrWord> words;
  final double? confidence;
  final AssistantBoundingBox? boundingBox;

  Map<String, Object?> toDeterministicMap() => {
        'text': text,
        'words': words.map((w) => w.toDeterministicMap()).toList(),
        'confidence': confidence,
        'boundingBox': boundingBox?.toDeterministicMap(),
      };
}

class AssistantOcrBlock {
  const AssistantOcrBlock({
    required this.text,
    this.lines = const [],
    this.confidence,
    this.boundingBox,
  });

  final String text;
  final List<AssistantOcrLine> lines;
  final double? confidence;
  final AssistantBoundingBox? boundingBox;

  Map<String, Object?> toDeterministicMap() => {
        'text': text,
        'lines': lines.map((l) => l.toDeterministicMap()).toList(),
        'confidence': confidence,
        'boundingBox': boundingBox?.toDeterministicMap(),
      };
}

class AssistantOcrPage {
  const AssistantOcrPage({
    required this.pageNumber,
    this.text = '',
    this.blocks = const [],
    this.confidence,
    this.language,
  });

  final int pageNumber;
  final String text;
  final List<AssistantOcrBlock> blocks;
  final double? confidence;
  final String? language;

  Map<String, Object?> toDeterministicMap() => {
        'pageNumber': pageNumber,
        'text': text,
        'blocks': blocks.map((b) => b.toDeterministicMap()).toList(),
        'confidence': confidence,
        'language': language,
      };
}

class AssistantOcrRequest {
  const AssistantOcrRequest({
    required this.referenceUri,
    this.fileName,
    this.mimeType,
    this.languageHint,
    this.correlationId,
  });

  final String referenceUri;
  final String? fileName;
  final String? mimeType;
  final String? languageHint;
  final String? correlationId;

  Map<String, Object?> toDeterministicMap() => {
        'referenceUri': referenceUri,
        'fileName': fileName,
        'mimeType': mimeType,
        'languageHint': languageHint,
        'correlationId': correlationId,
      };
}

class AssistantOcrResult {
  const AssistantOcrResult({
    required this.pages,
    this.fullText = '',
    this.language,
    this.confidence,
    this.characterCount = 0,
  });

  final List<AssistantOcrPage> pages;
  final String fullText;
  final String? language;
  final double? confidence;
  final int characterCount;

  static const empty = AssistantOcrResult(pages: []);

  Map<String, Object?> toDeterministicMap() => {
        'pages': pages.map((p) => p.toDeterministicMap()).toList(),
        'fullText': fullText,
        'language': language,
        'confidence': confidence,
        'characterCount': characterCount,
      };
}
