import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/settings/data/repositories/drift_company_profile_repository.dart';
import 'package:eventpro/features/settings/models/company_address.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftCompanyProfileRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftCompanyProfileRepository repository;

    final createdAt = DateTime(2024, 3, 2, 10, 15);
    final firstUpdatedAt = DateTime(2024, 3, 2, 11, 0);
    final secondUpdatedAt = DateTime(2024, 3, 3, 9, 0);

    CompanyProfile buildProfile({
      required String tradeName,
      required DateTime updatedAt,
    }) {
      return CompanyProfile(
        tradeName: tradeName,
        phoneDigits: '67999998888',
        address: const CompanyAddress(
          street: 'Rua B',
          number: '20',
          city: 'Campo Grande',
          state: 'MS',
        ),
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('company_profile_repo_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftCompanyProfileRepository(database);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('get returns null when profile was never saved', () async {
      expect(await repository.get(), isNull);
    });

    test('first upsert creates singleton profile', () async {
      final profile = buildProfile(
        tradeName: 'DJ Marcelo PP',
        updatedAt: firstUpdatedAt,
      );

      await repository.upsert(profile);

      final restored = await repository.get();
      expect(restored?.tradeName, 'DJ Marcelo PP');
      expect(restored?.createdAt, createdAt);
      expect(restored?.updatedAt, firstUpdatedAt);
      expect(restored?.address.street, 'Rua B');
    });

    test('second upsert updates same row and preserves createdAt', () async {
      await repository.upsert(
        buildProfile(tradeName: 'Primeiro', updatedAt: firstUpdatedAt),
      );

      await repository.upsert(
        buildProfile(tradeName: 'Atualizado', updatedAt: secondUpdatedAt),
      );

      final rows = await database.select(database.companyProfiles).get();
      expect(rows, hasLength(1));

      final restored = await repository.get();
      expect(restored?.tradeName, 'Atualizado');
      expect(restored?.createdAt, createdAt);
      expect(restored?.updatedAt, secondUpdatedAt);
    });

    test('close and reopen database keeps persisted profile', () async {
      await repository.upsert(
        buildProfile(tradeName: 'Persistido', updatedAt: firstUpdatedAt),
      );
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftCompanyProfileRepository(reopenedDb);

      final restored = await reopenedRepository.get();
      expect(restored?.tradeName, 'Persistido');
      expect(restored?.createdAt, createdAt);
    });
  });
}
