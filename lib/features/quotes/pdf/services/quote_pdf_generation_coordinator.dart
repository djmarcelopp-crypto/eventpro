import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/quotes_provider.dart';
import '../models/quote_pdf_ready_data.dart';
import '../providers/quote_pdf_providers.dart';
import '../utils/quote_pdf_document_builder.dart';
import '../utils/quote_pdf_filename_builder.dart';

abstract class QuotePdfGenerationCoordinator {
  static Future<QuotePdfGenerationResult> generate({
    required Ref ref,
    required String quoteId,
  }) async {
    final quote = ref.read(quotesProvider.notifier).findById(quoteId);
    if (quote == null) {
      return const QuotePdfGenerationFailed();
    }

    final buildResult = QuotePdfDocumentBuilder.build(quote);
    if (buildResult is QuotePdfBuildBlocked) {
      return QuotePdfGenerationBlocked(buildResult.message);
    }

    final success = buildResult as QuotePdfBuildSuccess;

    try {
      final logoBytes = await ref.read(quotePdfLogoLoaderProvider).load(
            logoReference: success.data.company.logoReference,
          );
      final fonts = await ref.read(quotePdfFontsProvider.future);
      final bytes = await ref.read(quotePdfGeneratorProvider).generate(
            data: success.data,
            fonts: fonts,
            logoBytes: logoBytes,
          );

      return QuotePdfGenerationReady(
        QuotePdfReadyData(
          bytes: bytes,
          filename: QuotePdfFilenameBuilder.build(quote.number),
          quoteNumber: quote.number,
        ),
      );
    } catch (_) {
      return const QuotePdfGenerationFailed();
    }
  }
}
