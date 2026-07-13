import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/settings/models/company_address.dart';
import 'package:eventpro/features/settings/models/company_payment_info.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/legal_representative.dart';
import 'package:eventpro/features/settings/models/pix_key_type.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_pix_key_type.dart';
import 'package:eventpro/features/quotes/utils/quote_company_snapshot_builder.dart';

void main() {
  group('QuoteCompanySnapshotBuilder', () {
    final fixedCapturedAt = DateTime(2026, 7, 13, 15, 30, 45);

    CompanyProfile minimumProfile() {
      return CompanyProfile(
        tradeName: 'DJ Marcelo PP',
        phoneDigits: '67999990000',
        whatsAppDigits: '67988887777',
        createdAt: fixedCapturedAt,
        updatedAt: fixedCapturedAt,
      );
    }

    CompanyProfile configuredProfile() {
      return CompanyProfile(
        tradeName: 'DJ Marcelo PP',
        legalName: 'Marcelo PP Festas LTDA',
        cnpjDigits: '11222333000181',
        phoneDigits: '67999990000',
        whatsAppDigits: '67988887777',
        email: 'contato@djmarcelo.com',
        address: const CompanyAddress(
          postalCode: '79002010',
          street: 'Rua Example',
          number: '100',
          city: 'Campo Grande',
          state: 'MS',
        ),
        legalRepresentative: const LegalRepresentative(
          fullName: 'Marcelo PP',
          cpfDigits: '52998224725',
          role: 'Sócio',
        ),
        paymentInfo: const CompanyPaymentInfo(
          pixKeyType: PixKeyType.email,
          pixKey: '  PIX@Empresa.COM ',
          beneficiaryName: 'Marcelo PP Festas LTDA',
          paymentTerms: '50% na reserva',
        ),
        logoReference: 'settings/logo/profile_1.png',
        createdAt: fixedCapturedAt,
        updatedAt: fixedCapturedAt,
      );
    }

    test('profile null retorna null', () {
      final snapshot = QuoteCompanySnapshotBuilder.fromProfile(
        profile: null,
        capturedAt: fixedCapturedAt,
      );

      expect(snapshot, isNull);
    });

    test('perfil mínimo retorna snapshot incompleto', () {
      final snapshot = QuoteCompanySnapshotBuilder.fromProfile(
        profile: minimumProfile(),
        capturedAt: fixedCapturedAt,
      );

      expect(snapshot, isNotNull);
      expect(snapshot!.captureStatus, QuoteCompanyCaptureStatus.incomplete);
      expect(snapshot.identification.tradeName, 'DJ Marcelo PP');
      expect(snapshot.contact.phoneDigits, '67999990000');
      expect(snapshot.contact.whatsAppDigits, '67988887777');
    });

    test('perfil configurado retorna snapshot completo', () {
      final snapshot = QuoteCompanySnapshotBuilder.fromProfile(
        profile: configuredProfile(),
        capturedAt: fixedCapturedAt,
        logoReference: 'quotes/company-assets/quote-1_123.png',
      );

      expect(snapshot, isNotNull);
      expect(snapshot!.captureStatus, QuoteCompanyCaptureStatus.configured);
      expect(snapshot.identification.cnpjDigits, '11222333000181');
      expect(snapshot.address.postalCode, '79002010');
      expect(snapshot.address.state, 'MS');
      expect(snapshot.legalRepresentative?.cpfDigits, '52998224725');
      expect(snapshot.payment?.pixKeyType, QuotePixKeyType.email);
      expect(snapshot.payment?.pixKey, 'pix@empresa.com');
      expect(snapshot.payment?.paymentTerms, '50% na reserva');
      expect(snapshot.logoReference, 'quotes/company-assets/quote-1_123.png');
    });

    test('capturedAt usa valor fornecido pelo chamador', () {
      final clock = DateTime(2026, 1, 5, 9, 15, 0);

      final snapshot = QuoteCompanySnapshotBuilder.fromProfile(
        profile: minimumProfile(),
        capturedAt: clock,
      );

      expect(snapshot!.capturedAt, clock);
    });

    test('telefone e WhatsApp independentes no builder', () {
      final profile = minimumProfile();

      final snapshot = QuoteCompanySnapshotBuilder.fromProfile(
        profile: profile,
        capturedAt: fixedCapturedAt,
      );

      expect(snapshot!.contact.phoneDigits, '67999990000');
      expect(snapshot.contact.whatsAppDigits, '67988887777');
      expect(
        snapshot.contact.phoneDigits,
        isNot(equals(snapshot.contact.whatsAppDigits)),
      );
    });

    test('CNPJ inválido não entra no snapshot', () {
      final profile = configuredProfile().copyWith(cnpjDigits: '00000000000000');

      final snapshot = QuoteCompanySnapshotBuilder.fromProfile(
        profile: profile,
        capturedAt: fixedCapturedAt,
      );

      expect(snapshot!.identification.cnpjDigits, isNull);
    });

    test('paymentTerms não mistura com outros campos', () {
      final snapshot = QuoteCompanySnapshotBuilder.fromProfile(
        profile: configuredProfile(),
        capturedAt: fixedCapturedAt,
      );

      expect(snapshot!.payment?.paymentTerms, '50% na reserva');
      expect(snapshot.identification.tradeName, isNot(contains('50%')));
    });
  });
}
