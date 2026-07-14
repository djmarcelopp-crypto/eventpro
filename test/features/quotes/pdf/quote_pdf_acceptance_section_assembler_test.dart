import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_acceptance_section_assembler.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_formatter.dart';

void main() {
  QuoteClientSnapshot sampleClient() {
    return const QuoteClientSnapshot(
      type: QuoteClientType.individual,
      displayName: 'Maria Silva',
      document: '52998224725',
    );
  }

  QuoteCompanySnapshot sampleCompany({
    QuoteCompanyLegalRepresentative? legalRepresentative,
  }) {
    return QuoteCompanySnapshot(
      identification: const QuoteCompanyIdentification(
        tradeName: 'DJ Marcelo PP',
        legalName: 'Marcelo PP Festas LTDA',
        cnpjDigits: '11222333000181',
      ),
      contact: const QuoteCompanyContact(),
      address: const QuoteCompanyAddress(),
      legalRepresentative: legalRepresentative,
      captureStatus: QuoteCompanyCaptureStatus.configured,
      capturedAt: DateTime(2026, 7, 13),
    );
  }

  group('QuotePdfAcceptanceSectionAssembler', () {
    test('monta seção completa com textos fixos e blocos de assinatura', () {
      final section = QuotePdfAcceptanceSectionAssembler.assemble(
        clientSnapshot: sampleClient(),
        companySnapshot: sampleCompany(
          legalRepresentative: const QuoteCompanyLegalRepresentative(
            fullName: 'Marcelo PP',
            cpfDigits: '52998224725',
          ),
        ),
      );

      expect(section.title, 'Aceite da proposta');
      expect(
        section.declarationText,
        QuotePdfFormatter.acceptanceDeclarationText,
      );
      expect(
        section.localAndDateLine,
        QuotePdfFormatter.acceptanceLocalAndDateLine,
      );
      expect(
        section.disclaimerText,
        QuotePdfFormatter.acceptanceDisclaimerText,
      );
      expect(section.approvedAtLabel, isNull);
      expect(section.contractorBlock.roleLabel, 'Contratante');
      expect(section.contracteeBlock.roleLabel, 'Contratada');
    });

    test('inclui approvedAtLabel com data e horário quando informado', () {
      final section = QuotePdfAcceptanceSectionAssembler.assemble(
        clientSnapshot: sampleClient(),
        companySnapshot: sampleCompany(),
        approvedAt: DateTime(2026, 7, 13, 14, 30),
      );

      expect(
        section.approvedAtLabel,
        'Aprovado no sistema em: 13 de julho de 2026 às 14:30',
      );
    });

    test('textos da seção não contêm assinatura eletrônica ou digital', () {
      final section = QuotePdfAcceptanceSectionAssembler.assemble(
        clientSnapshot: sampleClient(),
        companySnapshot: sampleCompany(),
        approvedAt: DateTime(2026, 7, 13, 14, 30),
      );

      const forbiddenTerms = [
        'assinatura eletrônica',
        'assinatura digital',
      ];

      final texts = [
        section.title,
        section.declarationText,
        section.localAndDateLine,
        section.disclaimerText,
        section.approvedAtLabel!,
        section.contractorBlock.roleLabel,
        section.contracteeBlock.roleLabel,
        ...section.contractorBlock.identificationLines,
        ...section.contracteeBlock.identificationLines,
      ];

      for (final text in texts) {
        for (final term in forbiddenTerms) {
          expect(text.toLowerCase().contains(term), isFalse, reason: text);
        }
      }
    });
  });
}
