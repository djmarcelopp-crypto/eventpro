import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/data/repositories/drift_client_repository.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/models/client_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftClientRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftClientRepository repository;

    final createdAt = DateTime(2024, 3, 2, 10, 15);
    final birthday = DateTime(1988, 12, 25);

    Client buildClient({
      required String id,
      required String name,
      DateTime? createdAtValue,
      ClientAddress? address,
      DateTime? birthdayValue,
    }) {
      return Client(
        id: id,
        createdAt: createdAtValue ?? createdAt,
        type: ClientType.individual,
        name: name,
        phone: '67999998888',
        address: address,
        birthday: birthdayValue,
        internalNotes: 'interno',
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('client_repo_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftClientRepository(database);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('CRUD persists all fields and preserves registration order', () async {
      final first = buildClient(id: 'client-1', name: 'Maria');
      final second = buildClient(
        id: 'client-2',
        name: 'João',
        createdAtValue: DateTime(2024, 3, 3),
        address: const ClientAddress(street: 'Rua B', number: '10'),
        birthdayValue: birthday,
      );

      await repository.insert(first);
      await repository.insert(second);

      final listed = await repository.listAll();
      expect(listed.map((client) => client.name).toList(), ['Maria', 'João']);
      expect(listed.last.address?.street, 'Rua B');
      expect(listed.last.birthday, DateTime(1988, 12, 25));

      final loaded = await repository.findById('client-1');
      expect(loaded?.name, 'Maria');

      final updated = first.copyWith(name: 'Maria Atualizada');
      await repository.update(updated);
      expect((await repository.findById('client-1'))?.name, 'Maria Atualizada');

      await repository.delete('client-1');
      expect(await repository.findById('client-1'), isNull);
      expect((await repository.listAll()).single.id, 'client-2');
    });

    test(
      'update persists createdAt when notifier rules are respected',
      () async {
        final client = buildClient(id: 'client-3', name: 'Ana');
        await repository.insert(client);

        final updated = client.copyWith(name: 'Ana Nova');
        await repository.update(updated);

        final restored = await repository.findById('client-3');
        expect(restored?.createdAt, createdAt);
        expect(restored?.name, 'Ana Nova');
      },
    );

    test('close and reopen database keeps persisted clients', () async {
      await repository.insert(buildClient(id: 'client-4', name: 'Persistido'));
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftClientRepository(reopenedDb);

      final clients = await reopenedRepository.listAll();
      expect(clients, hasLength(1));
      expect(clients.single.name, 'Persistido');
    });
  });
}
