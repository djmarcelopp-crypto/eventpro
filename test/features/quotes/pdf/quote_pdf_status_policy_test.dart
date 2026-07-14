import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_status_policy.dart';

void main() {
  group('QuotePdfStatusPolicy', () {
    test('rascunho usa marca d’água RASCUNHO sem badge', () {
      final overlay = QuotePdfStatusPolicy.overlayFor(QuoteStatus.draft);

      expect(overlay.watermarkText, 'RASCUNHO');
      expect(overlay.badgeText, isNull);
      expect(QuotePdfStatusPolicy.canPreview(QuoteStatus.draft), isTrue);
      expect(QuotePdfStatusPolicy.canExport(QuoteStatus.draft), isTrue);
    });

    test('enviado usa badge ENVIADO sem marca d’água', () {
      final overlay = QuotePdfStatusPolicy.overlayFor(QuoteStatus.sent);

      expect(overlay.watermarkText, isNull);
      expect(overlay.badgeText, 'ENVIADO');
    });

    test('aprovado usa badge APROVADO', () {
      final overlay = QuotePdfStatusPolicy.overlayFor(QuoteStatus.approved);

      expect(overlay.badgeText, 'APROVADO');
      expect(overlay.watermarkText, isNull);
    });

    test('recusado usa marca d’água e badge RECUSADO', () {
      final overlay = QuotePdfStatusPolicy.overlayFor(QuoteStatus.rejected);

      expect(overlay.watermarkText, 'RECUSADO');
      expect(overlay.badgeText, 'RECUSADO');
    });

    test('cancelado usa marca d’água e badge CANCELADO', () {
      final overlay = QuotePdfStatusPolicy.overlayFor(QuoteStatus.cancelled);

      expect(overlay.watermarkText, 'CANCELADO');
      expect(overlay.badgeText, 'CANCELADO');
    });
  });
}
