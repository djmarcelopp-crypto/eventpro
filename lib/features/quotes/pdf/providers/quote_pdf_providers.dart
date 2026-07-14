import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/quote_company_logo_storage_provider.dart';
import '../services/quote_pdf_export_service.dart';
import '../services/quote_pdf_file_writer_service.dart';
import '../services/quote_pdf_generator_service.dart';
import '../services/quote_pdf_logo_loader_service.dart';
import '../services/quote_pdf_save_dialog_service.dart';
import '../theme/quote_pdf_font_loader.dart';
import '../theme/quote_pdf_fonts.dart';

final quotePdfFontsProvider = FutureProvider<QuotePdfFonts>((ref) {
  return QuotePdfFontLoader.loadFromAssets();
});

final quotePdfGeneratorProvider = Provider<QuotePdfGenerator>((ref) {
  return const QuotePdfGeneratorService();
});

final quotePdfLogoLoaderProvider = Provider<QuotePdfLogoLoaderService>((ref) {
  return DefaultQuotePdfLogoLoaderService(
    ref.watch(quoteCompanyLogoStorageProvider),
  );
});

final quotePdfSaveDialogProvider = Provider<QuotePdfSaveDialogService>((ref) {
  return const FilePickerQuotePdfSaveDialogService();
});

final quotePdfFileWriterProvider = Provider<QuotePdfFileWriterService>((ref) {
  return const LocalQuotePdfFileWriterService();
});

final quotePdfExportServiceProvider = Provider<QuotePdfExportService>((ref) {
  return PlatformQuotePdfExportService(
    saveDialog: ref.watch(quotePdfSaveDialogProvider),
    fileWriter: ref.watch(quotePdfFileWriterProvider),
  );
});
