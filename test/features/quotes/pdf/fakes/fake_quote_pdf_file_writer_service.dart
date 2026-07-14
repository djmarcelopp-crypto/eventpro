import 'dart:typed_data';

import 'package:eventpro/features/quotes/pdf/services/quote_pdf_file_writer_service.dart';

class FakeQuotePdfFileWriterService implements QuotePdfFileWriterService {
  var writeCallCount = 0;
  var nextWriteSuccess = true;
  String? lastPath;
  Uint8List? lastBytes;
  Object? errorToThrow;

  @override
  Future<bool> writeBytes({
    required String path,
    required Uint8List bytes,
  }) async {
    writeCallCount++;
    lastPath = path;
    lastBytes = bytes;

    if (errorToThrow != null) {
      throw errorToThrow!;
    }

    return nextWriteSuccess;
  }
}
