import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/logistics/data/mappers/vehicle_mapper.dart';
import 'package:eventpro/features/logistics/data/mappers/vehicle_type_mapper.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VehicleMapper / VehicleTypeMapper', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;

    final createdAt = DateTime(2026, 7, 17, 12);
    final updatedAt = DateTime(2026, 7, 17, 15);

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('vehicle_mapper_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      await database.into(database.vehicleTypes).insert(
            VehicleTypeMapper.toInsertCompanion(
              VehicleType(
                id: 'type-1',
                name: 'Van',
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
            ),
          );
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('VehicleTypeMapper round-trips fields', () async {
      final original = VehicleType(
        id: 'type-2',
        name: 'Truck',
        description: 'Carga',
        active: false,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      await database
          .into(database.vehicleTypes)
          .insert(VehicleTypeMapper.toInsertCompanion(original));
      final row = await (database.select(database.vehicleTypes)
            ..where((tbl) => tbl.id.equals('type-2')))
          .getSingle();
      expect(VehicleTypeMapper.toDomain(row), original);
    });

    test('VehicleMapper round-trips fields and empty observations as null',
        () async {
      final original = Vehicle(
        id: 'vehicle-1',
        plate: 'ABC1D23',
        description: 'Van',
        vehicleTypeId: 'type-1',
        payloadCapacityKg: 800.5,
        volumeCapacityM3: 8.25,
        observations: 'Nota',
        status: VehicleStatus.maintenance,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      final companion = VehicleMapper.toInsertCompanion(original);
      expect(companion.status.value, 'maintenance');
      expect(companion.observations.value, 'Nota');

      await database.into(database.vehicles).insert(companion);
      final row = await (database.select(database.vehicles)
            ..where((tbl) => tbl.id.equals('vehicle-1')))
          .getSingle();
      expect(VehicleMapper.toDomain(row), original);

      await database.vehiclesDao.deleteById('vehicle-1');

      final emptyObs = Vehicle(
        id: 'vehicle-2',
        plate: 'XYZ9Z99',
        vehicleTypeId: 'type-1',
        payloadCapacityKg: 0,
        volumeCapacityM3: 0,
        status: VehicleStatus.available,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      final emptyCompanion = VehicleMapper.toInsertCompanion(emptyObs);
      expect(emptyCompanion.observations.value, isNull);

      await database.into(database.vehicles).insert(emptyCompanion);
      final restored = VehicleMapper.toDomain(
        await (database.select(database.vehicles)
              ..where((tbl) => tbl.id.equals('vehicle-2')))
            .getSingle(),
      );
      expect(restored.observations, '');
    });
  });
}
