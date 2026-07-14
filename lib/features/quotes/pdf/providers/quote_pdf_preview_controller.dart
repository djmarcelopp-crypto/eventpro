import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/quotes_provider.dart';
import '../models/quote_pdf_export_result.dart';
import '../models/quote_pdf_preview_state.dart';
import '../models/quote_pdf_ready_data.dart';
import '../services/quote_pdf_generation_coordinator.dart';
import 'quote_pdf_providers.dart';

class QuotePdfPreviewController extends Notifier<QuotePdfPreviewState> {
  QuotePdfPreviewController(this._quoteId);

  final String _quoteId;
  Uint8List? _cachedBytes;
  var _generationStarted = false;

  int get generationCount => _generationCount;
  int _generationCount = 0;

  @override
  QuotePdfPreviewState build() {
    Future.microtask(_generateOnce);
    return const QuotePdfPreviewLoading();
  }

  Future<void> _generateOnce() async {
    if (_generationStarted) {
      return;
    }
    _generationStarted = true;

    final quote = ref.read(quotesProvider.notifier).findById(_quoteId);
    if (!ref.mounted) {
      return;
    }
    if (quote == null) {
      state = const QuotePdfPreviewNotFound();
      return;
    }

    final result = await QuotePdfGenerationCoordinator.generate(
      ref: ref,
      quoteId: _quoteId,
    );

    if (!ref.mounted) {
      return;
    }

    switch (result) {
      case QuotePdfGenerationBlocked(:final message):
        state = QuotePdfPreviewBlocked(message);
      case QuotePdfGenerationFailed():
        state = const QuotePdfPreviewError();
      case QuotePdfGenerationReady(:final data):
        _generationCount++;
        _cachedBytes = data.bytes;
        state = QuotePdfPreviewReady(
          bytes: data.bytes,
          filename: data.filename,
          quoteNumber: data.quoteNumber,
        );
    }
  }

  Future<QuotePdfExportResult> exportPdf() async {
    final current = state;
    if (current is! QuotePdfPreviewReady || current.isExporting) {
      return const QuotePdfExportCancelled();
    }

    final bytes = _cachedBytes;
    if (bytes == null || bytes.isEmpty) {
      return const QuotePdfExportFailed();
    }

    state = current.copyWith(isExporting: true);

    try {
      return await ref.read(quotePdfExportServiceProvider).export(
            bytes: bytes,
            filename: current.filename,
          );
    } finally {
      final latest = state;
      if (latest is QuotePdfPreviewReady) {
        state = latest.copyWith(isExporting: false);
      }
    }
  }
}

final quotePdfPreviewControllerProvider = NotifierProvider.autoDispose
    .family<QuotePdfPreviewController, QuotePdfPreviewState, String>(
  QuotePdfPreviewController.new,
);
