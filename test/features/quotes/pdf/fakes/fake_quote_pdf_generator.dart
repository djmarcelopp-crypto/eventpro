import 'dart:typed_data';

import 'package:eventpro/features/quotes/pdf/services/quote_pdf_generator_service.dart';
import 'package:eventpro/features/quotes/pdf/theme/quote_pdf_fonts.dart';
import 'package:eventpro/features/quotes/pdf/models/quote_pdf_document_data.dart';

class FakeQuotePdfGenerator implements QuotePdfGenerator {
  FakeQuotePdfGenerator({this.bytesToReturn, this.error, this.delay});

  Uint8List? bytesToReturn;
  Object? error;
  Duration? delay;
  var generateCallCount = 0;
  Uint8List? lastLogoBytes;
  QuotePdfDocumentData? lastDocumentData;

  @override
  Future<Uint8List> generate({
    required QuotePdfDocumentData data,
    required QuotePdfFonts fonts,
    Uint8List? logoBytes,
  }) async {
    generateCallCount++;
    lastDocumentData = data;
    lastLogoBytes = logoBytes;

    if (error != null) {
      throw error!;
    }

    if (delay != null) {
      await Future<void>.delayed(delay!);
    }

    return bytesToReturn ?? Uint8List.fromList(const [0x25, 0x50, 0x44, 0x46, 0x2D]);
  }
}
