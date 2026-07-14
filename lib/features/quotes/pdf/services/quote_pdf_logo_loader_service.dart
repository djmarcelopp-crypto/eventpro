import 'dart:typed_data';

import '../../data/services/quote_company_logo_storage_service.dart';
import 'quote_pdf_logo_loader.dart';

abstract class QuotePdfLogoLoaderService {
  Future<Uint8List?> load({required String? logoReference});
}

class DefaultQuotePdfLogoLoaderService implements QuotePdfLogoLoaderService {
  const DefaultQuotePdfLogoLoaderService(this._storage);

  final QuoteCompanyLogoStorageService _storage;

  @override
  Future<Uint8List?> load({required String? logoReference}) {
    return QuotePdfLogoLoader.load(
      storage: _storage,
      logoReference: logoReference,
    );
  }
}
