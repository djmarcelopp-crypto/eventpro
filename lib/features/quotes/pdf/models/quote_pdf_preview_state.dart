import 'dart:typed_data';

sealed class QuotePdfPreviewState {
  const QuotePdfPreviewState();
}

class QuotePdfPreviewLoading extends QuotePdfPreviewState {
  const QuotePdfPreviewLoading();
}

class QuotePdfPreviewNotFound extends QuotePdfPreviewState {
  const QuotePdfPreviewNotFound();
}

class QuotePdfPreviewBlocked extends QuotePdfPreviewState {
  const QuotePdfPreviewBlocked(this.message);

  final String message;
}

class QuotePdfPreviewError extends QuotePdfPreviewState {
  const QuotePdfPreviewError();
}

class QuotePdfPreviewReady extends QuotePdfPreviewState {
  const QuotePdfPreviewReady({
    required this.bytes,
    required this.filename,
    required this.quoteNumber,
    this.isExporting = false,
  });

  final Uint8List bytes;
  final String filename;
  final String quoteNumber;
  final bool isExporting;

  QuotePdfPreviewReady copyWith({
    Uint8List? bytes,
    String? filename,
    String? quoteNumber,
    bool? isExporting,
  }) {
    return QuotePdfPreviewReady(
      bytes: bytes ?? this.bytes,
      filename: filename ?? this.filename,
      quoteNumber: quoteNumber ?? this.quoteNumber,
      isExporting: isExporting ?? this.isExporting,
    );
  }
}
