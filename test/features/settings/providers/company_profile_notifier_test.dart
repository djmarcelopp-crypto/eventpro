import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/settings/models/company_address.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/legal_representative.dart';
import 'package:eventpro/features/settings/providers/company_profile_clock_provider.dart';
import 'package:eventpro/features/settings/providers/company_profile_provider.dart';

void main() {
  group('CompanyProfileNotifier', () {
    late ProviderContainer container;
    final fixedNow = DateTime(2026, 7, 13, 10, 30);
    final laterNow = DateTime(2026, 7, 13, 11, 45);

    setUp(() {
      container = ProviderContainer(
        overrides: [
          companyProfileClockProvider.overrideWithValue(() => fixedNow),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    CompanyProfile sampleDraft({String tradeName = 'DJ Marcelo PP'}) {
      return CompanyProfile(
        tradeName: tradeName,
        phoneDigits: '67999998888',
        createdAt: DateTime(2010, 1, 1),
        updatedAt: DateTime(2010, 1, 1),
      );
    }

    test('inicia sem perfil configurado', () {
      expect(container.read(companyProfileProvider), isNull);
    });

    test('primeiro save cria perfil com createdAt e updatedAt do relógio', () {
      final notifier = container.read(companyProfileProvider.notifier);

      notifier.save(sampleDraft());

      final profile = container.read(companyProfileProvider)!;
      expect(profile.tradeName, 'DJ Marcelo PP');
      expect(profile.createdAt, fixedNow);
      expect(profile.updatedAt, fixedNow);
    });

    test('segundo save preserva createdAt e atualiza updatedAt', () {
      var currentNow = fixedNow;
      final mutableContainer = ProviderContainer(
        overrides: [
          companyProfileClockProvider.overrideWithValue(() => currentNow),
        ],
      );
      addTearDown(mutableContainer.dispose);

      final notifier = mutableContainer.read(companyProfileProvider.notifier);
      notifier.save(sampleDraft());

      currentNow = laterNow;
      notifier.save(
        sampleDraft(tradeName: 'DJ Marcelo PP Atualizado'),
      );

      final profile = mutableContainer.read(companyProfileProvider)!;
      expect(profile.tradeName, 'DJ Marcelo PP Atualizado');
      expect(profile.createdAt, fixedNow);
      expect(profile.updatedAt, laterNow);
    });

    test('não duplica perfil em saves sucessivos', () {
      final notifier = container.read(companyProfileProvider.notifier);
      notifier.save(sampleDraft());
      final firstCreatedAt = container.read(companyProfileProvider)!.createdAt;

      notifier.save(
        sampleDraft().copyWith(
          legalName: 'Marcelo PP Festas LTDA',
          address: const CompanyAddress(
            street: 'Rua A',
            number: '10',
            city: 'Campo Grande',
            state: 'MS',
            postalCode: '79002010',
          ),
          legalRepresentative: const LegalRepresentative(
            fullName: 'Marcelo PP',
            cpfDigits: '52998224725',
          ),
          cnpjDigits: '11222333000181',
        ),
      );

      final profile = container.read(companyProfileProvider);
      expect(profile, isNotNull);
      expect(profile!.legalName, 'Marcelo PP Festas LTDA');
      expect(profile.createdAt, firstCreatedAt);
    });
  });
}
