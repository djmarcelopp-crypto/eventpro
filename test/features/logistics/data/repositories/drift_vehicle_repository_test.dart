import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/logistics/data/repositories/drift_vehicle_repository.dart';
import 'package:eventpro/features/logistics/data/repositories/drift_vehicle_type_repository.dart';
import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DriftVehicleRepository / DriftVehicleTypeRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftVehicleRepository vehicleRepository;
    late DriftVehicleTypeRepository typeRepository;

    final createdAt = DateTime(2026, 7, 17, 9);
    final updatedAt = DateTime(2026, 7, 17, 9);

    Future<void> seedType() async {
      await typeRepository.insert(
        VehicleType(
          id: 'type-1',
          name: 'Van',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );
    }

    Vehicle buildVehicle({
      required String id,
      required String plate,
      VehicleStatus status = VehicleStatus.available,
    }) {
      return Vehicle(
        id: id,
        plate: plate,
        vehicleTypeId: 'type-1',
        payloadCapacityKg: 800,
        volumeCapacityM3: 8,
        status: status,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('vehicle_repo_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      vehicleRepository = DriftVehicleRepository(database);
      typeRepository = DriftVehicleTypeRepository(database);
      await seedType();
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('type and vehicle CRUD orders by name/plate', () async {
      await typeRepository.insert(
        VehicleType(
          id: 'type-2',
          name: 'Alpha',
          createdAt: createdAt,
          updatedAt: updatedAt,
        ),
      );
      expect(
        (await typeRepository.listAll()).map((t) => t.name).toList(),
        ['Alpha', 'Van'],
      );

      await vehicleRepository.insert(buildVehicle(id: 'v-z', plate: 'ZZZ9Z99'));
      await vehicleRepository.insert(
        buildVehicle(
          id: 'v-a',
          plate: 'AAA1A11',
          status: VehicleStatus.inactive,
        ),
      );

      expect(
        (await vehicleRepository.listAll()).map((v) => v.plate).toList(),
        ['AAA1A11', 'ZZZ9Z99'],
      );

      final updated = buildVehicle(id: 'v-a', plate: 'AAA1A11')
          .copyWith(payloadCapacityKg: 1000);
      await vehicleRepository.update(updated);
      expect(
        (await vehicleRepository.findById('v-a'))?.payloadCapacityKg,
        1000,
      );

      await vehicleRepository.delete('v-a');
      expect(await vehicleRepository.findById('v-a'), isNull);
    });

    test('FK restrict blocks orphan insert and type delete while in use',
        () async {
      await vehicleRepository.insert(buildVehicle(id: 'v-1', plate: 'ABC1D23'));

      expect(
        () => vehicleRepository.insert(
          buildVehicle(id: 'v-2', plate: 'DEF2E34').copyWith(
            vehicleTypeId: 'missing',
          ),
        ),
        throwsA(isA<Exception>()),
      );

      expect(
        () => typeRepository.delete('type-1'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
