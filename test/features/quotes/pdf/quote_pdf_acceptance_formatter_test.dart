import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_formatter.dart';

void main() {
  QuoteClientSnapshot individualClient({
    String name = 'Maria Silva',
    String? document,
  }) {
    return QuoteClientSnapshot(
      type: QuoteClientType.individual,
      displayName: name,
      document: document,
    );
  }

  QuoteClientSnapshot companyClient({
    String displayName = 'Festas Premium',
    String? legalName,
    String? document,
  }) {
    return QuoteClientSnapshot(
      type: QuoteClientType.company,
      displayName: displayName,
      legalName: legalName,
      document: document,
    );
  }

  QuoteCompanySnapshot companySnapshot({
    String tradeName = 'DJ Marcelo PP',
    String? legalName,
    String? cnpjDigits,
    QuoteCompanyLegalRepresentative? legalRepresentative,
  }) {
    return QuoteCompanySnapshot(
      identification: QuoteCompanyIdentification(
        tradeName: tradeName,
        legalName: legalName,
        cnpjDigits: cnpjDigits,
      ),
      contact: const QuoteCompanyContact(),
      address: const QuoteCompanyAddress(),
      legalRepresentative: legalRepresentative,
      captureStatus: QuoteCompanyCaptureStatus.configured,
      capturedAt: DateTime(2026, 7, 13),
    );
  }

  group('QuotePdfFormatter acceptance helpers', () {
    test('disclaimer usa texto genérico sem aviso específico sobre Aprovado', () {
      expect(
        QuotePdfFormatter.acceptanceDisclaimerText,
        'Os status registrados no EventPro servem apenas ao controle interno '
        'e não substituem as assinaturas do contratante e da contratada.',
      );
      expect(
        QuotePdfFormatter.acceptanceDisclaimerText,
        isNot(contains("O status ‘Aprovado’")),
      );
      expect(
        QuotePdfFormatter.acceptanceDisclaimerText,
        isNot(contains('não substitui a assinatura')),
      );
    });

    test('textos fixos não contêm assinatura eletrônica ou digital', () {
      const forbiddenTerms = [
        'assinatura eletrônica',
        'assinatura digital',
        'Assinatura eletrônica',
        'Assinatura digital',
      ];

      final texts = [
        QuotePdfFormatter.acceptanceDeclarationText,
        QuotePdfFormatter.acceptanceLocalAndDateLine,
        QuotePdfFormatter.acceptanceDisclaimerText,
      ];

      for (final text in texts) {
        for (final term in forbiddenTerms) {
          expect(text.contains(term), isFalse, reason: text);
        }
      }
    });

    test('formatApprovedAtSystemLabel inclui data longa e horário', () {
      final label = QuotePdfFormatter.formatApprovedAtSystemLabel(
        DateTime(2026, 7, 13, 14, 30),
      );

      expect(label, 'Aprovado no sistema em: 13 de julho de 2026 às 14:30');
      expect(label, isNot(contains('/')));
    });

    test('formatApprovedAtSystemLabel não reutiliza formatProposalDate', () {
      final approvedAt = DateTime(2026, 7, 13, 14, 30);
      final proposalDate = QuotePdfFormatter.formatProposalDate(approvedAt);

      expect(proposalDate, '13 de julho de 2026');
      expect(
        QuotePdfFormatter.formatApprovedAtSystemLabel(approvedAt),
        isNot(equals(proposalDate)),
      );
    });

    group('contratante PF', () {
      test('monta nome e CPF formatado', () {
        final block = QuotePdfFormatter.buildContractorSignatureBlock(
          individualClient(document: '52998224725'),
        );

        expect(block.roleLabel, 'Contratante');
        expect(block.identificationLines, [
          'Maria Silva',
          'CPF 529.982.247-25',
        ]);
      });

      test('omite CPF quando documento ausente', () {
        final block = QuotePdfFormatter.buildContractorSignatureBlock(
          individualClient(),
        );

        expect(block.identificationLines, ['Maria Silva']);
      });
    });

    group('contratante PJ', () {
      test('prefere razão social e inclui CNPJ', () {
        final block = QuotePdfFormatter.buildContractorSignatureBlock(
          companyClient(
            displayName: 'Festas Premium',
            legalName: 'Festas Premium Eventos LTDA',
            document: '11222333000181',
          ),
        );

        expect(block.identificationLines, [
          'Festas Premium Eventos LTDA',
          'CNPJ 11.222.333/0001-81',
        ]);
      });

      test('usa nome de exibição quando razão social ausente', () {
        final block = QuotePdfFormatter.buildContractorSignatureBlock(
          companyClient(displayName: 'Festas Premium'),
        );

        expect(block.identificationLines, ['Festas Premium']);
      });

      test('omite CNPJ quando documento ausente', () {
        final block = QuotePdfFormatter.buildContractorSignatureBlock(
          companyClient(
            legalName: 'Festas Premium Eventos LTDA',
          ),
        );

        expect(block.identificationLines, ['Festas Premium Eventos LTDA']);
      });
    });

    group('contratada', () {
      test('com representante inclui nome, CPF, cargo, empresa e CNPJ', () {
        final block = QuotePdfFormatter.buildContracteeSignatureBlock(
          companySnapshot(
            tradeName: 'DJ Marcelo PP',
            legalName: 'Marcelo PP Festas LTDA',
            cnpjDigits: '11222333000181',
            legalRepresentative: const QuoteCompanyLegalRepresentative(
              fullName: 'Marcelo PP',
              cpfDigits: '52998224725',
              role: 'Sócio administrador',
            ),
          ),
        );

        expect(block.roleLabel, 'Contratada');
        expect(block.identificationLines, [
          'Marcelo PP',
          'CPF 529.982.247-25',
          'Sócio administrador',
          'Marcelo PP Festas LTDA',
          'CNPJ 11.222.333/0001-81',
        ]);
      });

      test('representante parcial omite campos ausentes', () {
        final block = QuotePdfFormatter.buildContracteeSignatureBlock(
          companySnapshot(
            legalName: 'Marcelo PP Festas LTDA',
            legalRepresentative: const QuoteCompanyLegalRepresentative(
              fullName: 'Marcelo PP',
              role: 'Procurador',
            ),
          ),
        );

        expect(block.identificationLines, [
          'Marcelo PP',
          'Procurador',
          'Marcelo PP Festas LTDA',
        ]);
      });

      test('sem representante usa rótulo Representante da contratada', () {
        final block = QuotePdfFormatter.buildContracteeSignatureBlock(
          companySnapshot(
            tradeName: 'DJ Marcelo PP',
            legalName: 'Marcelo PP Festas LTDA',
            cnpjDigits: '11222333000181',
          ),
        );

        expect(block.roleLabel, 'Representante da contratada');
        expect(block.identificationLines, [
          'Marcelo PP Festas LTDA',
          'CNPJ 11.222.333/0001-81',
        ]);
      });

      test('sem representante usa nome fantasia quando razão social ausente', () {
        final block = QuotePdfFormatter.buildContracteeSignatureBlock(
          companySnapshot(tradeName: 'DJ Marcelo PP'),
        );

        expect(block.roleLabel, 'Representante da contratada');
        expect(block.identificationLines, ['DJ Marcelo PP']);
      });

      test('suporta nomes e razões sociais extensos', () {
        const longLegalName =
            'Associação Beneficente de Eventos e Festas do Centro-Oeste LTDA';
        const longRepresentative =
            'Dr. Marcelo de Oliveira Pires Pereira Junior';

        final block = QuotePdfFormatter.buildContracteeSignatureBlock(
          companySnapshot(
            tradeName: 'DJ Marcelo PP',
            legalName: longLegalName,
            legalRepresentative: const QuoteCompanyLegalRepresentative(
              fullName: longRepresentative,
            ),
          ),
        );

        expect(block.identificationLines.first, longRepresentative);
        expect(block.identificationLines, contains(longLegalName));
      });
    });

    test('listas de identificação são imutáveis', () {
      final contractor = QuotePdfFormatter.buildContractorSignatureBlock(
        individualClient(document: '52998224725'),
      );
      final contractee = QuotePdfFormatter.buildContracteeSignatureBlock(
        companySnapshot(
          legalName: 'Marcelo PP Festas LTDA',
          cnpjDigits: '11222333000181',
        ),
      );

      expect(
        () => contractor.identificationLines.add('extra'),
        throwsUnsupportedError,
      );
      expect(
        () => contractee.identificationLines.add('extra'),
        throwsUnsupportedError,
      );
    });
  });
}
