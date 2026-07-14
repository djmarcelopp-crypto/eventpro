import 'dart:typed_data';

import 'package:eventpro/features/quotes/pdf/models/quote_pdf_export_result.dart';
import 'package:eventpro/features/quotes/pdf/services/quote_pdf_export_service.dart';

class FakeQuotePdfExportService implements QuotePdfExportService {
  var exportCallCount = 0;
  Uint8List? lastBytes;
  String? lastFilename;
  QuotePdfExportResult nextResult = const QuotePdfExportSuccess();

  @override
  Future<QuotePdfExportResult> export({
    required Uint8List bytes,
    required String filename,
  }) async {
    exportCallCount++;
    lastBytes = bytes;
    lastFilename = filename;
    return nextResult;
  }
}
