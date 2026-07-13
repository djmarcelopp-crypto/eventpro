import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/settings/models/company_address.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/company_profile_status.dart';
import 'package:eventpro/features/settings/models/legal_representative.dart';
import 'package:eventpro/features/settings/utils/company_profile_completeness.dart';

void main() {
  group('CompanyProfileCompleteness', () {
    final fixedNow = DateTime(2026, 7, 13, 10, 0);

    CompanyProfile minimumProfile() {
      return CompanyProfile(
        tradeName: 'DJ Marcelo PP',
        phoneDigits: '67999998888',
        createdAt: fixedNow,
        updatedAt: fixedNow,
      );
    }

    CompanyProfile configuredProfile() {
      return CompanyProfile(
        tradeName: 'DJ Marcelo PP',
        legalName: 'Marcelo PP Festas LTDA',
        cnpjDigits: '11222333000181',
        phoneDigits: '67999998888',
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
        ),
        createdAt: fixedNow,
        updatedAt: fixedNow,
      );
    }

    test('null retorna não configurado', () {
      expect(
        CompanyProfileCompleteness.status(null),
        CompanyProfileStatus.notConfigured,
      );
    });

    test('mínimos salvos sem recomendados retorna incompleto', () {
      final status = CompanyProfileCompleteness.status(minimumProfile());
      expect(status, CompanyProfileStatus.incomplete);
    });

    test('recomendados completos retorna configurado', () {
      final status = CompanyProfileCompleteness.status(configuredProfile());
      expect(status, CompanyProfileStatus.configured);
    });

    test('lista pendências profissionais', () {
      final missing =
          CompanyProfileCompleteness.missingRecommendations(minimumProfile());

      expect(missing, contains('Razão social'));
      expect(missing, contains('CNPJ'));
      expect(missing, contains('Endereço principal'));
      expect(missing, contains('Responsável legal'));
    });

    test('logo e PIX ausentes não impedem configurado', () {
      final profile = configuredProfile();
      expect(profile.logoReference, isNull);
      expect(profile.paymentInfo, isNull);
      expect(
        CompanyProfileCompleteness.status(profile),
        CompanyProfileStatus.configured,
      );
    });
  });
}
