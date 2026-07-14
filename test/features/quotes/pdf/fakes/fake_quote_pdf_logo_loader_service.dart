import 'dart:typed_data';

import 'package:eventpro/features/quotes/pdf/services/quote_pdf_logo_loader_service.dart';

class FakeQuotePdfLogoLoaderService implements QuotePdfLogoLoaderService {
  FakeQuotePdfLogoLoaderService({this.bytesToReturn});

  Uint8List? bytesToReturn;
  var loadCallCount = 0;
  String? lastLogoReference;

  @override
  Future<Uint8List?> load({required String? logoReference}) async {
    loadCallCount++;
    lastLogoReference = logoReference;
    return bytesToReturn;
  }
}
