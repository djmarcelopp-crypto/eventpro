import 'dart:io';
import 'dart:typed_data';

abstract class QuotePdfFileWriterService {
  Future<bool> writeBytes({
    required String path,
    required Uint8List bytes,
  });
}

class LocalQuotePdfFileWriterService implements QuotePdfFileWriterService {
  const LocalQuotePdfFileWriterService();

  @override
  Future<bool> writeBytes({
    required String path,
    required Uint8List bytes,
  }) async {
    final file = File(path);
    await file.writeAsBytes(bytes, flush: true);

    if (!await file.exists()) {
      return false;
    }

    final writtenLength = await file.length();
    return writtenLength == bytes.length;
  }
}
