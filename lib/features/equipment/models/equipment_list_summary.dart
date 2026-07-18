import 'equipment.dart';
import 'equipment_status.dart';

/// Simple inventory list counters for UI cards (not availability / booking).
class EquipmentListSummary {
  const EquipmentListSummary({
    required this.totalItems,
    required this.totalQuantity,
    required this.availableCount,
    required this.reservedCount,
    required this.maintenanceCount,
    required this.inactiveCount,
  });

  static const empty = EquipmentListSummary(
    totalItems: 0,
    totalQuantity: 0,
    availableCount: 0,
    reservedCount: 0,
    maintenanceCount: 0,
    inactiveCount: 0,
  );

  factory EquipmentListSummary.fromItems(List<Equipment> items) {
    var totalQuantity = 0;
    var availableCount = 0;
    var reservedCount = 0;
    var maintenanceCount = 0;
    var inactiveCount = 0;

    for (final item in items) {
      totalQuantity += item.totalQuantity;
      switch (item.status) {
        case EquipmentStatus.available:
          availableCount++;
        case EquipmentStatus.reserved:
          reservedCount++;
        case EquipmentStatus.maintenance:
          maintenanceCount++;
        case EquipmentStatus.inactive:
          inactiveCount++;
      }
    }

    return EquipmentListSummary(
      totalItems: items.length,
      totalQuantity: totalQuantity,
      availableCount: availableCount,
      reservedCount: reservedCount,
      maintenanceCount: maintenanceCount,
      inactiveCount: inactiveCount,
    );
  }

  final int totalItems;
  final int totalQuantity;
  final int availableCount;
  final int reservedCount;
  final int maintenanceCount;
  final int inactiveCount;
}
