/// Conflict when a quote requests more units than remain available in its
/// period, given other overlapping quote demand for the same equipment.
///
/// Pure domain value — never persisted.
class EquipmentReservationConflict {
  const EquipmentReservationConflict({
    required this.quoteId,
    required this.equipmentId,
    required this.requestedQuantity,
    required this.availableQuantity,
    required this.periodStart,
    required this.periodEnd,
  });

  final String quoteId;
  final String equipmentId;
  final int requestedQuantity;
  final int availableQuantity;
  final DateTime periodStart;
  final DateTime periodEnd;

  int get shortfall => requestedQuantity - availableQuantity;
}
