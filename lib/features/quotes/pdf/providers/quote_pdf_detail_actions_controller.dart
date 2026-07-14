import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quote_pdf_export_result.dart';
import '../models/quote_pdf_ready_data.dart';
import '../services/quote_pdf_generation_coordinator.dart';
import 'quote_pdf_providers.dart';

class QuotePdfDetailActionsState {
  const QuotePdfDetailActionsState({this.busy = false});

  final bool busy;
}

class QuotePdfDetailActionsController
    extends Notifier<QuotePdfDetailActionsState> {
  QuotePdfDetailActionsController(this._quoteId);

  final String _quoteId;
  QuotePdfReadyData? _cachedReady;
  var _operationInFlight = false;

  int get generationCount => _generationCount;
  int _generationCount = 0;

  QuotePdfReadyData? get cachedReady => _cachedReady;

  @override
  QuotePdfDetailActionsState build() {
    return const QuotePdfDetailActionsState();
  }

  Future<QuotePdfExportResult> exportDirect() async {
    if (_operationInFlight) {
      return const QuotePdfExportCancelled();
    }

    _operationInFlight = true;
    state = const QuotePdfDetailActionsState(busy: true);

    try {
      if (_cachedReady == null) {
        final result = await QuotePdfGenerationCoordinator.generate(
          ref: ref,
          quoteId: _quoteId,
        );

        if (!ref.mounted) {
          return const QuotePdfExportCancelled();
        }

        switch (result) {
          case QuotePdfGenerationBlocked():
            return const QuotePdfExportFailed();
          case QuotePdfGenerationFailed():
            return const QuotePdfExportFailed();
          case QuotePdfGenerationReady(:final data):
            _generationCount++;
            _cachedReady = data;
        }
      }

      final ready = _cachedReady!;
      return await ref.read(quotePdfExportServiceProvider).export(
            bytes: ready.bytes,
            filename: ready.filename,
          );
    } finally {
      _operationInFlight = false;
      if (ref.mounted) {
        state = const QuotePdfDetailActionsState(busy: false);
      }
    }
  }
}

final quotePdfDetailActionsControllerProvider = NotifierProvider.autoDispose
    .family<QuotePdfDetailActionsController, QuotePdfDetailActionsState,
        String>(
  QuotePdfDetailActionsController.new,
);
