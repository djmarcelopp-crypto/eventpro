import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/data/mappers/client_mapper.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/models/client_address.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final createdAt = DateTime(2024, 1, 10, 8, 30);
  final birthday = DateTime(1990, 7, 15, 23, 45);

  Client buildSampleClient({
    ClientAddress? address,
    DateTime? birthdayValue,
    String? internalNotes,
    bool clearAddress = false,
  }) {
    return Client(
      id: 'client-1',
      createdAt: createdAt,
      type: ClientType.company,
      name: 'Eventos Silva LTDA',
      tradeName: 'Eventos Silva',
      phone: '6732321234',
      whatsApp: '67981495959',
      email: 'contato@eventos.com',
      document: '12345678000190',
      address: clearAddress ? null : address,
      instagram: '@eventos',
      birthday: birthdayValue,
      internalNotes: internalNotes,
    );
  }

  group('ClientMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('client_mapper_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    Future<Client> persistAndReload(Client client) async {
      await database
          .into(database.clients)
          .insert(ClientMapper.toInsertCompanion(client));
      final row = await (database.select(
        database.clients,
      )..where((tbl) => tbl.id.equals(client.id))).getSingle();
      return ClientMapper.toDomain(row);
    }

    test('round-trips all populated fields including full address', () async {
      final original = buildSampleClient(
        address: const ClientAddress(
          postalCode: '79002010',
          street: 'Rua A',
          number: '100',
          complement: 'Sala 2',
          neighborhood: 'Centro',
          city: 'Campo Grande',
          state: 'MS',
        ),
        birthdayValue: birthday,
        internalNotes: 'Nota interna',
      );

      final restored = await persistAndReload(original);

      expect(restored.id, original.id);
      expect(restored.createdAt, original.createdAt);
      expect(restored.type, original.type);
      expect(restored.name, original.name);
      expect(restored.tradeName, original.tradeName);
      expect(restored.phone, original.phone);
      expect(restored.whatsApp, original.whatsApp);
      expect(restored.email, original.email);
      expect(restored.document, original.document);
      expect(restored.instagram, original.instagram);
      expect(restored.internalNotes, original.internalNotes);
      expect(restored.birthday, DateTime(1990, 7, 15));
      expect(restored.address?.postalCode, '79002010');
      expect(restored.address?.street, 'Rua A');
      expect(restored.address?.number, '100');
      expect(restored.address?.complement, 'Sala 2');
      expect(restored.address?.neighborhood, 'Centro');
      expect(restored.address?.city, 'Campo Grande');
      expect(restored.address?.state, 'MS');
    });

    test('round-trips nullable fields as null', () async {
      final original = Client(
        id: 'client-nullables',
        createdAt: createdAt,
        type: ClientType.individual,
        name: 'Cliente Simples',
        phone: '67999998888',
      );

      final restored = await persistAndReload(original);

      expect(restored.tradeName, isNull);
      expect(restored.address, isNull);
      expect(restored.birthday, isNull);
      expect(restored.internalNotes, isNull);
    });

    test('preserves birthday day without timezone conversion', () async {
      final original = buildSampleClient(birthdayValue: birthday);

      final restored = await persistAndReload(original);

      expect(restored.birthday?.year, 1990);
      expect(restored.birthday?.month, 7);
      expect(restored.birthday?.day, 15);
    });

    test(
      'update companion clears address columns when address is null',
      () async {
        final withAddress = buildSampleClient(
          address: const ClientAddress(street: 'Rua B', number: '20'),
        );
        await database
            .into(database.clients)
            .insert(ClientMapper.toInsertCompanion(withAddress));

        final cleared = buildSampleClient(clearAddress: true);
        await database
            .update(database.clients)
            .replace(ClientMapper.toUpdateCompanion(cleared));

        final row = await (database.select(
          database.clients,
        )..where((tbl) => tbl.id.equals(cleared.id))).getSingle();
        final restored = ClientMapper.toDomain(row);

        expect(restored.address, isNull);
        expect(row.street, isNull);
        expect(row.number, isNull);
      },
    );
  });
}
