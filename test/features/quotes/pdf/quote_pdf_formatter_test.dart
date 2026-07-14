import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_pix_key_type.dart';
import 'package:eventpro/features/quotes/pdf/utils/quote_pdf_formatter.dart';

void main() {
  group('QuotePdfFormatter', () {
    test('formata data da proposta com acentos', () {
      expect(
        QuotePdfFormatter.formatProposalDate(DateTime(2026, 7, 13)),
        '13 de julho de 2026',
      );
    });

    test('omite razão social repetida e compacta documentos da empresa', () {
      expect(
        QuotePdfFormatter.formatCompanyLegalLine(
          tradeName: 'DJ Marcelo PP',
          legalName: 'DJ Marcelo PP',
          cnpj: '11.222.333/0001-81',
          stateRegistration: '123456',
        ),
        'CNPJ 11.222.333/0001-81 • IE 123456',
      );
    });

    test('omite telefone duplicado do WhatsApp nos contatos', () {
      final inline = QuotePdfFormatter.formatCompanyContactsInline(
        const QuoteCompanyContact(
          phoneDigits: '67999990000',
          whatsAppDigits: '67999990000',
          email: 'contato@empresa.com',
        ),
      );

      expect(inline, isNotNull);
      expect(inline!.contains('•'), isTrue);
      expect(inline.split('•').length, 2);
    });

    test('compõe rodapé com prioridade website → instagram → fallback', () {
      expect(
        QuotePdfFormatter.composeFooterProfessionalText(
          tradeName: 'DJ Marcelo PP',
          website: 'https://djmarcelo.com',
          instagram: '@djmarcelo',
        ),
        'https://djmarcelo.com',
      );

      expect(
        QuotePdfFormatter.composeFooterProfessionalText(
          tradeName: 'DJ Marcelo PP',
          instagram: '@djmarcelo',
        ),
        '@djmarcelo',
      );

      expect(
        QuotePdfFormatter.composeFooterProfessionalText(
          tradeName: 'DJ Marcelo PP',
        ),
        'DJ Marcelo PP · Proposta comercial',
      );
    });

    test('formata chave PIX completa por tipo', () {
      expect(
        QuotePdfFormatter.formatPixKey(
          type: QuotePixKeyType.email,
          key: 'pix@empresa.com',
        ),
        'pix@empresa.com',
      );

      expect(
        QuotePdfFormatter.formatPixKey(
          type: QuotePixKeyType.cpf,
          key: '52998224725',
        ),
        '529.982.247-25',
      );
    });

    test('monta intervalo de horário do evento', () {
      expect(
        QuotePdfFormatter.formatEventTimeRange(
          startTime: '18:00',
          endTime: '23:00',
        ),
        '18:00 – 23:00',
      );
    });

    test('omite valores monetários não positivos', () {
      expect(QuotePdfFormatter.positiveMoneyLabel(0), isNull);
      expect(QuotePdfFormatter.positiveMoneyLabel(10_000), 'R\$ 100,00');
    });

    test('compacta unidades padrão apenas para apresentação do PDF', () {
      expect(QuotePdfFormatter.formatCompactUnitForPdf('Unidade'), 'un.');
      expect(QuotePdfFormatter.formatCompactUnitForPdf('Diária'), 'diária');
      expect(QuotePdfFormatter.formatCompactUnitForPdf('Hora'), 'hora');
      expect(QuotePdfFormatter.formatCompactUnitForPdf('Metro'), 'm');
      expect(QuotePdfFormatter.formatCompactUnitForPdf('Metro quadrado'), 'm²');
      expect(QuotePdfFormatter.formatCompactUnitForPdf('Evento'), 'evento');
      expect(QuotePdfFormatter.formatCompactUnitForPdf('Serviço'), 'serviço');
      expect(
        QuotePdfFormatter.formatCompactUnitForPdf('Pacote premium'),
        'Pacote premium',
      );
    });
  });
}
