import 'equipment_availability.dart';

/// Aggregate counts of equipment availability levels.
class EquipmentAvailabilitySummary {
  const EquipmentAvailabilitySummary({
    required this.items,
    required this.fullyAvailableCount,
    required this.partiallyAvailableCount,
    required this.unavailableCount,
  });

  factory EquipmentAvailabilitySummary.fromItems(
    List<EquipmentAvailability> items,
  ) {
    var fullyAvailableCount = 0;
    var partiallyAvailableCount = 0;
    var unavailableCount = 0;

    for (final item in items) {
      switch (item.level) {
        case EquipmentAvailabilityLevel.fullyAvailable:
          fullyAvailableCount++;
        case EquipmentAvailabilityLevel.partiallyAvailable:
          partiallyAvailableCount++;
        case EquipmentAvailabilityLevel.unavailable:
          unavailableCount++;
      }
    }

    return EquipmentAvailabilitySummary(
      items: List<EquipmentAvailability>.unmodifiable(items),
      fullyAvailableCount: fullyAvailableCount,
      partiallyAvailableCount: partiallyAvailableCount,
      unavailableCount: unavailableCount,
    );
  }

  static const empty = EquipmentAvailabilitySummary(
    items: [],
    fullyAvailableCount: 0,
    partiallyAvailableCount: 0,
    unavailableCount: 0,
  );

  final List<EquipmentAvailability> items;
  final int fullyAvailableCount;
  final int partiallyAvailableCount;
  final int unavailableCount;

  int get totalEquipmentCount => items.length;
}
