import 'package:eventpro/features/quotes/pdf/services/quote_pdf_save_dialog_service.dart';

class FakeQuotePdfSaveDialogService implements QuotePdfSaveDialogService {
  String? nextPath;
  Object? errorToThrow;
  var pickCallCount = 0;
  String? lastFilename;

  @override
  Future<String?> pickSavePath({required String filename}) async {
    pickCallCount++;
    lastFilename = filename;

    if (errorToThrow != null) {
      throw errorToThrow!;
    }

    return nextPath;
  }
}
