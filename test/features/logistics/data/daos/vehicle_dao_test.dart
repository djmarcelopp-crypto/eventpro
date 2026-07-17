import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VehicleTypesDao / VehiclesDao', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('vehicle_dao_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('DAO CRUD for types and vehicles', () async {
      final typesDao = database.vehicleTypesDao;
      final vehiclesDao = database.vehiclesDao;

      await typesDao.insertRow(
        VehicleTypesCompanion.insert(
          id: 'type-1',
          name: 'Van',
          active: true,
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );

      expect((await typesDao.getAllOrdered()).single.name, 'Van');
      expect((await typesDao.getById('type-1'))?.id, 'type-1');

      await vehiclesDao.insertRow(
        VehiclesCompanion.insert(
          id: 'v-1',
          plate: 'ABC1D23',
          description: 'Branca',
          vehicleTypeId: 'type-1',
          payloadCapacityKg: 800,
          volumeCapacityM3: 8,
          status: 'available',
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_000_000,
        ),
      );

      expect((await vehiclesDao.getAllOrdered()).single.plate, 'ABC1D23');
      expect((await vehiclesDao.getById('v-1'))?.status, 'available');

      final updated = await vehiclesDao.updateRow(
        VehiclesCompanion.insert(
          id: 'v-1',
          plate: 'ABC1D23',
          description: 'Branca',
          vehicleTypeId: 'type-1',
          payloadCapacityKg: 900,
          volumeCapacityM3: 8,
          status: 'maintenance',
          createdAt: 1_700_000_000_000,
          updatedAt: 1_700_000_100_000,
        ),
      );
      expect(updated, isTrue);
      expect((await vehiclesDao.getById('v-1'))?.status, 'maintenance');

      expect(await vehiclesDao.deleteById('v-1'), isTrue);
      expect(await vehiclesDao.getById('v-1'), isNull);
      expect(await typesDao.deleteById('type-1'), isTrue);
    });
  });
}
