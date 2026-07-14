import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_document_builder.dart';

import '../quotes_test_helpers.dart';

void main() {
  group('QuotePdf security — view model', () {
    test('internalNotes nunca entra no documento', () {
      final quote = sampleQuoteDraft(
        companySnapshot: sampleCompanySnapshot(),
      ).copyWith(
        number: 'ORC-2026-0099',
        notes: 'Observação pública',
        internalNotes: 'Segredo interno da equipe',
        status: QuoteStatus.draft,
        approvedAt: null,
      );

      final result = QuotePdfDocumentBuilder.build(quote);
      final data = (result as QuotePdfBuildSuccess).data;

      expect(data.proposalNotes, 'Observação pública');
      expect(data.proposalNotes, isNot(contains('Segredo interno')));
    });

    test('alteração posterior em Settings não altera documento histórico', () {
      final snapshot = sampleCompanySnapshot(tradeName: 'Empresa Original');

      final quote = sampleQuoteDraft(
        companySnapshot: snapshot,
      ).copyWith(
        number: 'ORC-2026-0100',
        approvedAt: null,
      );

      final firstData =
          (QuotePdfDocumentBuilder.build(quote) as QuotePdfBuildSuccess).data;
      final secondData =
          (QuotePdfDocumentBuilder.build(quote) as QuotePdfBuildSuccess).data;

      expect(firstData.company.tradeName, 'Empresa Original');
      expect(secondData.company.tradeName, 'Empresa Original');
      expect(firstData.footerProfessionalText, contains('Empresa Original'));
    });
  });
}
