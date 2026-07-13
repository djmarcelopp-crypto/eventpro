import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_pix_key_type.dart';

void main() {
  group('QuoteCompanySnapshot', () {
    final fixedCapturedAt = DateTime(2026, 7, 13, 15, 30, 45);

    QuoteCompanySnapshot sampleSnapshot({
      String? phoneDigits = '67999990000',
      String? whatsAppDigits = '67988887777',
      bool clearPhone = false,
      bool clearWhatsApp = false,
    }) {
      return QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(
          tradeName: 'DJ Marcelo PP',
          legalName: 'Marcelo PP Festas LTDA',
          cnpjDigits: '11222333000181',
        ),
        contact: QuoteCompanyContact(
          phoneDigits: clearPhone ? null : phoneDigits,
          whatsAppDigits: clearWhatsApp ? null : whatsAppDigits,
          email: 'contato@djmarcelo.com',
        ),
        address: const QuoteCompanyAddress(
          postalCode: '79002010',
          street: 'Rua Example',
          number: '100',
          city: 'Campo Grande',
          state: 'MS',
        ),
        legalRepresentative: const QuoteCompanyLegalRepresentative(
          fullName: 'Marcelo PP',
          cpfDigits: '52998224725',
          role: 'Sócio',
        ),
        payment: const QuoteCompanyPayment(
          pixKeyType: QuotePixKeyType.email,
          pixKey: 'pix@empresa.com',
          beneficiaryName: 'Marcelo PP Festas LTDA',
          paymentTerms: '50% na reserva, 50% no evento',
        ),
        logoReference: 'quotes/company-assets/quote-1_123.png',
        captureStatus: QuoteCompanyCaptureStatus.configured,
        capturedAt: fixedCapturedAt,
      );
    }

    test('telefone e WhatsApp permanecem independentes', () {
      final snapshot = sampleSnapshot(
        phoneDigits: '67911112222',
        whatsAppDigits: '67933334444',
      );

      expect(snapshot.contact.phoneDigits, '67911112222');
      expect(snapshot.contact.whatsAppDigits, '67933334444');
      expect(snapshot.contact.phoneDigits, isNot(snapshot.contact.whatsAppDigits));
    });

    test('apenas telefone sem WhatsApp é válido', () {
      final snapshot = sampleSnapshot(clearWhatsApp: true);

      expect(snapshot.contact.phoneDigits, '67999990000');
      expect(snapshot.contact.whatsAppDigits, isNull);
    });

    test('apenas WhatsApp sem telefone é válido', () {
      final snapshot = sampleSnapshot(clearPhone: true);

      expect(snapshot.contact.phoneDigits, isNull);
      expect(snapshot.contact.whatsAppDigits, '67988887777');
    });

    test('submodelos são imutáveis por construção', () {
      final snapshot = sampleSnapshot();

      expect(snapshot.identification.tradeName, 'DJ Marcelo PP');
      expect(snapshot.captureStatus, QuoteCompanyCaptureStatus.configured);
      expect(snapshot.capturedAt, fixedCapturedAt);
      expect(snapshot.payment?.paymentTerms, '50% na reserva, 50% no evento');
    });

    test('contato vazio reporta isEmpty', () {
      const contact = QuoteCompanyContact();
      expect(contact.isEmpty, isTrue);
    });

    test('endereço vazio reporta isEmpty', () {
      const address = QuoteCompanyAddress();
      expect(address.isEmpty, isTrue);
    });
  });
}
