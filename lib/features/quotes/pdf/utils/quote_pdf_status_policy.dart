import '../../models/quote_status.dart';
import '../models/quote_pdf_status_overlay.dart';

abstract class QuotePdfStatusPolicy {
  static const draftWatermark = 'RASCUNHO';
  static const rejectedWatermark = 'RECUSADO';
  static const cancelledWatermark = 'CANCELADO';

  static const sentBadge = 'ENVIADO';
  static const approvedBadge = 'APROVADO';
  static const rejectedBadge = 'RECUSADO';
  static const cancelledBadge = 'CANCELADO';

  static QuotePdfStatusOverlay overlayFor(QuoteStatus status) {
    return switch (status) {
      QuoteStatus.draft => const QuotePdfStatusOverlay(
          watermarkText: draftWatermark,
        ),
      QuoteStatus.sent => const QuotePdfStatusOverlay(
          badgeText: sentBadge,
        ),
      QuoteStatus.approved => const QuotePdfStatusOverlay(
          badgeText: approvedBadge,
        ),
      QuoteStatus.rejected => const QuotePdfStatusOverlay(
          watermarkText: rejectedWatermark,
          badgeText: rejectedBadge,
        ),
      QuoteStatus.cancelled => const QuotePdfStatusOverlay(
          watermarkText: cancelledWatermark,
          badgeText: cancelledBadge,
        ),
    };
  }

  static bool canPreview(QuoteStatus status) => true;

  static bool canExport(QuoteStatus status) => true;
}
