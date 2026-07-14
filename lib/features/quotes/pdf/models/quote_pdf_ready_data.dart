import 'dart:typed_data';

class QuotePdfReadyData {
  const QuotePdfReadyData({
    required this.bytes,
    required this.filename,
    required this.quoteNumber,
  });

  final Uint8List bytes;
  final String filename;
  final String quoteNumber;
}

sealed class QuotePdfGenerationResult {
  const QuotePdfGenerationResult();
}

class QuotePdfGenerationBlocked extends QuotePdfGenerationResult {
  const QuotePdfGenerationBlocked(this.message);

  final String message;
}

class QuotePdfGenerationFailed extends QuotePdfGenerationResult {
  const QuotePdfGenerationFailed();
}

class QuotePdfGenerationReady extends QuotePdfGenerationResult {
  const QuotePdfGenerationReady(this.data);

  final QuotePdfReadyData data;
}
