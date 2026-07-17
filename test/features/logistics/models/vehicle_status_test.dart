import 'package:eventpro/features/logistics/models/vehicle_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('VehicleStatus', () {
    test('exposes all expected values', () {
      expect(VehicleStatus.values, [
        VehicleStatus.available,
        VehicleStatus.maintenance,
        VehicleStatus.unavailable,
        VehicleStatus.inactive,
      ]);
    });

    test('labels em português', () {
      expect(VehicleStatus.available.label, 'Disponível');
      expect(VehicleStatus.maintenance.label, 'Manutenção');
      expect(VehicleStatus.unavailable.label, 'Indisponível');
      expect(VehicleStatus.inactive.label, 'Inativo');
    });
  });
}
