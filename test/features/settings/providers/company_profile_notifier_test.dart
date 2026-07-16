import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/settings/models/company_address.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:eventpro/features/settings/models/legal_representative.dart';
import 'package:eventpro/features/settings/providers/company_profile_clock_provider.dart';
import 'package:eventpro/features/settings/providers/company_profile_provider.dart';

import '../fakes/company_profile_repository_test_overrides.dart';
import '../fakes/fake_company_profile_repository.dart';

void main() {
  group('CompanyProfileNotifier', () {
    late ProviderContainer container;
    final fixedNow = DateTime(2026, 7, 13, 10, 30);
    final laterNow = DateTime(2026, 7, 13, 11, 45);

    setUp(() {
      container = ProviderContainer(
        overrides: [
          companyProfileClockProvider.overrideWithValue(() => fixedNow),
          ...companyProfileRepositoryOverrides(),
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

    test('hydrate substitui o state pelo perfil informado', () {
      final profile = sampleDraft();

      container.read(companyProfileProvider.notifier).hydrate(profile);

      expect(container.read(companyProfileProvider), profile);
    });

    test('hydrate aceita null quando não há perfil salvo', () {
      container.read(companyProfileProvider.notifier).hydrate(sampleDraft());
      container.read(companyProfileProvider.notifier).hydrate(null);

      expect(container.read(companyProfileProvider), isNull);
    });

    test(
      'primeiro save cria perfil com createdAt e updatedAt do relógio',
      () async {
        final notifier = container.read(companyProfileProvider.notifier);

        final saved = await notifier.save(sampleDraft());
        expect(saved, isTrue);

        final profile = container.read(companyProfileProvider)!;
        expect(profile.tradeName, 'DJ Marcelo PP');
        expect(profile.createdAt, fixedNow);
        expect(profile.updatedAt, fixedNow);
      },
    );

    test('segundo save preserva createdAt e atualiza updatedAt', () async {
      var currentNow = fixedNow;
      final mutableContainer = ProviderContainer(
        overrides: [
          companyProfileClockProvider.overrideWithValue(() => currentNow),
          ...companyProfileRepositoryOverrides(),
        ],
      );
      addTearDown(mutableContainer.dispose);

      final notifier = mutableContainer.read(companyProfileProvider.notifier);
      await notifier.save(sampleDraft());

      currentNow = laterNow;
      final saved = await notifier.save(
        sampleDraft(tradeName: 'DJ Marcelo PP Atualizado'),
      );
      expect(saved, isTrue);

      final profile = mutableContainer.read(companyProfileProvider)!;
      expect(profile.tradeName, 'DJ Marcelo PP Atualizado');
      expect(profile.createdAt, fixedNow);
      expect(profile.updatedAt, laterNow);
    });

    test('não duplica perfil em saves sucessivos', () async {
      final notifier = container.read(companyProfileProvider.notifier);
      await notifier.save(sampleDraft());
      final firstCreatedAt = container.read(companyProfileProvider)!.createdAt;

      await notifier.save(
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

    test('falha no repositório preserva state anterior', () async {
      final fakeRepository = FakeCompanyProfileRepository();
      final failingContainer = ProviderContainer(
        overrides: [
          companyProfileClockProvider.overrideWithValue(() => fixedNow),
          ...companyProfileRepositoryOverrides(repository: fakeRepository),
        ],
      );
      addTearDown(failingContainer.dispose);

      final notifier = failingContainer.read(companyProfileProvider.notifier);
      await notifier.save(sampleDraft());
      final beforeFailure = failingContainer.read(companyProfileProvider);

      fakeRepository.shouldFailOnNextOperation = true;
      final saved = await notifier.save(
        sampleDraft(tradeName: 'Falha esperada'),
      );

      expect(saved, isFalse);
      expect(failingContainer.read(companyProfileProvider), beforeFailure);
    });
  });
}
