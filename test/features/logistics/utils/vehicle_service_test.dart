import 'package:eventpro/features/logistics/models/vehicle.dart';
import 'package:eventpro/features/logistics/models/vehicle_operation_result.dart';
import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:eventpro/features/logistics/models/vehicle_type.dart';
import 'package:eventpro/features/logistics/utils/vehicle_service.dart';
import 'package:eventpro/features/logistics/utils/vehicle_validator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../fakes/fake_vehicle_repository.dart';
import '../fakes/fake_vehicle_type_repository.dart';

void main() {
  group('VehicleService', () {
    late FakeVehicleTypeRepository typeRepository;
    late FakeVehicleRepository vehicleRepository;
    final fixedNow = DateTime(2030, 1, 1, 12);
    final earlier = DateTime(2020, 1, 1);

    VehicleService buildService({DateTime? now}) {
      return VehicleService(
        vehicleRepository: vehicleRepository,
        typeRepository: typeRepository,
        clock: () => now ?? fixedNow,
      );
    }

    VehicleType buildType({String id = 'type-1', bool active = true}) {
      return VehicleType(
        id: id,
        name: 'Van',
        active: active,
        createdAt: earlier,
        updatedAt: earlier,
      );
    }

    Vehicle buildDraft({
      String plate = 'abc1d23',
      String vehicleTypeId = 'type-1',
      double payloadCapacityKg = 800,
      double volumeCapacityM3 = 8,
      VehicleStatus status = VehicleStatus.available,
    }) {
      return Vehicle(
        id: '',
        plate: plate,
        vehicleTypeId: vehicleTypeId,
        payloadCapacityKg: payloadCapacityKg,
        volumeCapacityM3: volumeCapacityM3,
        status: status,
        createdAt: earlier,
        updatedAt: earlier,
      );
    }

    setUp(() async {
      typeRepository = FakeVehicleTypeRepository();
      vehicleRepository = FakeVehicleRepository();
      await typeRepository.insert(buildType());
    });

    test('create persists with normalized plate and clock timestamps',
        () async {
      final result = await buildService().create(buildDraft());

      expect(result.isSuccess, isTrue);
      expect(result.vehicle!.plate, 'ABC1D23');
      expect(result.vehicle!.createdAt, fixedNow);
      expect(result.vehicle!.updatedAt, fixedNow);
      expect(result.vehicle!.id, isNotEmpty);
    });

    test('rejects blank plate', () async {
      final result = await buildService().create(buildDraft(plate: ' '));
      expect(result.status, VehicleOperationStatus.validationFailed);
      expect(result.errors, contains(VehicleValidator.plateRequiredError));
    });

    test('rejects duplicate plate case-insensitively', () async {
      await buildService().create(buildDraft(plate: 'ABC1D23'));
      final result = await buildService().create(buildDraft(plate: 'abc1d23'));
      expect(result.status, VehicleOperationStatus.duplicatePlate);
    });

    test('rejects missing type', () async {
      final result =
          await buildService().create(buildDraft(vehicleTypeId: 'missing'));
      expect(result.status, VehicleOperationStatus.typeNotFound);
    });

    test('rejects inactive type', () async {
      await typeRepository.update(buildType(active: false));
      final result = await buildService().create(buildDraft());
      expect(result.status, VehicleOperationStatus.typeInactive);
    });

    test('rejects negative capacities', () async {
      final result = await buildService().create(
        buildDraft(payloadCapacityKg: -1, volumeCapacityM3: -2),
      );
      expect(result.status, VehicleOperationStatus.validationFailed);
    });

    test('update preserves createdAt and updates updatedAt', () async {
      final created = (await buildService(now: earlier).create(buildDraft()))
          .vehicle!;
      final result = await buildService().update(
        created.copyWith(description: 'Atualizada'),
      );

      expect(result.isSuccess, isTrue);
      expect(result.vehicle!.createdAt, earlier);
      expect(result.vehicle!.updatedAt, fixedNow);
      expect(result.vehicle!.description, 'Atualizada');
    });

    test('delete removes existing vehicle', () async {
      final created =
          (await buildService().create(buildDraft())).vehicle!;
      final result = await buildService().delete(created.id);
      expect(result.isDeleted, isTrue);
      expect(await vehicleRepository.findById(created.id), isNull);
    });

    test('delete returns notFound for unknown id', () async {
      final result = await buildService().delete('missing');
      expect(result.status, VehicleOperationStatus.notFound);
    });
  });
}
