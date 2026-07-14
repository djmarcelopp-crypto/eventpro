import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_acceptance_policy.dart';

void main() {
  group('QuotePdfAcceptancePolicy', () {
    test('inclui aceite em Enviado', () {
      expect(
        QuotePdfAcceptancePolicy.shouldIncludeAcceptanceSection(
          QuoteStatus.sent,
        ),
        isTrue,
      );
    });

    test('inclui aceite em Aprovado', () {
      expect(
        QuotePdfAcceptancePolicy.shouldIncludeAcceptanceSection(
          QuoteStatus.approved,
        ),
        isTrue,
      );
    });

    test('omite aceite em Rascunho', () {
      expect(
        QuotePdfAcceptancePolicy.shouldIncludeAcceptanceSection(
          QuoteStatus.draft,
        ),
        isFalse,
      );
    });

    test('omite aceite em Recusado', () {
      expect(
        QuotePdfAcceptancePolicy.shouldIncludeAcceptanceSection(
          QuoteStatus.rejected,
        ),
        isFalse,
      );
    });

    test('omite aceite em Cancelado', () {
      expect(
        QuotePdfAcceptancePolicy.shouldIncludeAcceptanceSection(
          QuoteStatus.cancelled,
        ),
        isFalse,
      );
    });
  });
}
