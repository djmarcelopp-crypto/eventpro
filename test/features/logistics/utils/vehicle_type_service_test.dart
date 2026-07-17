import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';
import 'package:eventpro/features/logistics/models/vehicle_type_operation_result.dart';
import 'package:eventpro/features/logistics/utils/vehicle_type_service.dart';
import 'package:eventpro/features/logistics/utils/vehicle_type_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_vehicle_repository.dart';
import '../fakes/fake_vehicle_type_repository.dart';

void main() {
  group('VehicleTypeService', () {
    late FakeVehicleTypeRepository typeRepository;
    late FakeVehicleRepository vehicleRepository;
    final fixedNow = DateTime(2030, 1, 1, 12);
    final earlier = DateTime(2020, 1, 1);

    VehicleTypeService buildService({DateTime? now}) {
      return VehicleTypeService(
        typeRepository: typeRepository,
        vehicleRepository: vehicleRepository,
        clock: () => now ?? fixedNow,
      );
    }

    VehicleType buildDraft({String name = 'Van'}) {
      return VehicleType(
        id: '',
        name: name,
        createdAt: earlier,
        updatedAt: earlier,
      );
    }

    setUp(() {
      typeRepository = FakeVehicleTypeRepository();
      vehicleRepository = FakeVehicleRepository();
    });

    test('create persists trimmed name with clock timestamps', () async {
      final result = await buildService().create(buildDraft(name: '  Van  '));
      expect(result.isSuccess, isTrue);
      expect(result.type!.name, 'Van');
      expect(result.type!.createdAt, fixedNow);
      expect(result.type!.updatedAt, fixedNow);
    });

    test('rejects blank name', () async {
      final result = await buildService().create(buildDraft(name: ' '));
      expect(result.status, VehicleTypeOperationStatus.validationFailed);
      expect(result.errors, contains(VehicleTypeValidator.nameRequiredError));
    });

    test('rejects duplicate name case-insensitively', () async {
      await buildService().create(buildDraft(name: 'Van'));
      final result = await buildService().create(buildDraft(name: 'van'));
      expect(result.status, VehicleTypeOperationStatus.duplicateName);
    });

    test('activate and deactivate update active flag', () async {
      final created = (await buildService().create(buildDraft())).type!;
      final deactivated = await buildService().deactivate(created.id);
      expect(deactivated.type!.active, isFalse);

      final activated = await buildService().activate(created.id);
      expect(activated.type!.active, isTrue);
      expect(activated.type!.createdAt, created.createdAt);
    });

    test('delete blocked when type is in use', () async {
      final created = (await buildService().create(buildDraft())).type!;
      await vehicleRepository.insert(
        Vehicle(
          id: 'v1',
          plate: 'ABC1D23',
          vehicleTypeId: created.id,
          payloadCapacityKg: 1,
          volumeCapacityM3: 1,
          status: VehicleStatus.available,
          createdAt: earlier,
          updatedAt: earlier,
        ),
      );

      final result = await buildService().delete(created.id);
      expect(result.isBlockedByUsage, isTrue);
      expect(result.blockingVehicleCount, 1);
    });

    test('delete removes unused type', () async {
      final created = (await buildService().create(buildDraft())).type!;
      final result = await buildService().delete(created.id);
      expect(result.isDeleted, isTrue);
      expect(await typeRepository.findById(created.id), isNull);
    });
  });
}
