import 'package:eventpro/features/equipment/models/equipment_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EquipmentStatus', () {
    test('exposes all expected values', () {
      expect(EquipmentStatus.values, [
        EquipmentStatus.available,
        EquipmentStatus.reserved,
        EquipmentStatus.maintenance,
        EquipmentStatus.inactive,
      ]);
    });

    test('labels em português', () {
      expect(EquipmentStatus.available.label, 'Disponível');
      expect(EquipmentStatus.reserved.label, 'Reservado');
      expect(EquipmentStatus.maintenance.label, 'Manutenção');
      expect(EquipmentStatus.inactive.label, 'Inativo');
    });
  });
}
