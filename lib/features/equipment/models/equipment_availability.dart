import 'equipment_consuming_quote.dart';
import 'equipment_reservation_conflict.dart';

/// Availability level derived from peak concurrent demand vs stock.
///
/// Independent of [Equipment.status] — status is never mutated by this model.
enum EquipmentAvailabilityLevel {
  /// No active quote demand overlaps for this equipment.
  fullyAvailable,

  /// Some units are reserved by overlapping quotes, but stock remains.
  partiallyAvailable,

  /// Peak reserved demand covers (or exceeds) total stock.
  unavailable,
}

/// Dynamic availability snapshot for one [Equipment] item.
///
/// Quantities are computed in memory from `totalQuantity` and quote lines —
/// never persisted as columns.
class EquipmentAvailability {
  const EquipmentAvailability({
    required this.equipmentId,
    required this.totalQuantity,
    required this.reservedQuantity,
    required this.availableQuantity,
    required this.level,
    required this.consumingQuotes,
    required this.conflicts,
  });

  final String equipmentId;

  /// Owned stock ([Equipment.totalQuantity]).
  final int totalQuantity;

  /// Peak concurrent reserved quantity across overlapping quote periods.
  final int reservedQuantity;

  /// `max(0, totalQuantity - reservedQuantity)`.
  final int availableQuantity;

  final EquipmentAvailabilityLevel level;

  final List<EquipmentConsumingQuote> consumingQuotes;
  final List<EquipmentReservationConflict> conflicts;

  bool get hasConflicts => conflicts.isNotEmpty;
  bool get isFullyAvailable =>
      level == EquipmentAvailabilityLevel.fullyAvailable;
  bool get isPartiallyAvailable =>
      level == EquipmentAvailabilityLevel.partiallyAvailable;
  bool get isUnavailable => level == EquipmentAvailabilityLevel.unavailable;
}
