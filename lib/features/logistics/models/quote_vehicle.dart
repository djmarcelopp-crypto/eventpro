/// Planned vehicle assignment attached to a quote (logistics).
///
/// Does **not** mutate [Vehicle.status] or create GPS/routes — planning only.
class QuoteVehicle {
  const QuoteVehicle({
    required this.id,
    required this.quoteId,
    required this.vehicleId,
    required this.freightCostCents,
    required this.createdAt,
    required this.updatedAt,
    this.driverTeamMemberId,
    this.plannedDepartureAt,
    this.plannedReturnAt,
    this.notes,
  });

  final String id;
  final String quoteId;
  final String vehicleId;
  final String? driverTeamMemberId;
  final DateTime? plannedDepartureAt;
  final DateTime? plannedReturnAt;

  /// Freight cost snapshot in cents. Must be >= 0.
  final int freightCostCents;

  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  QuoteVehicle copyWith({
    String? id,
    String? quoteId,
    String? vehicleId,
    String? driverTeamMemberId,
    DateTime? plannedDepartureAt,
    DateTime? plannedReturnAt,
    int? freightCostCents,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearDriver = false,
    bool clearPlannedDeparture = false,
    bool clearPlannedReturn = false,
    bool clearNotes = false,
  }) {
    return QuoteVehicle(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      vehicleId: vehicleId ?? this.vehicleId,
      driverTeamMemberId: clearDriver
          ? null
          : (driverTeamMemberId ?? this.driverTeamMemberId),
      plannedDepartureAt: clearPlannedDeparture
          ? null
          : (plannedDepartureAt ?? this.plannedDepartureAt),
      plannedReturnAt: clearPlannedReturn
          ? null
          : (plannedReturnAt ?? this.plannedReturnAt),
      freightCostCents: freightCostCents ?? this.freightCostCents,
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is QuoteVehicle &&
            other.id == id &&
            other.quoteId == quoteId &&
            other.vehicleId == vehicleId &&
            other.driverTeamMemberId == driverTeamMemberId &&
            other.plannedDepartureAt == plannedDepartureAt &&
            other.plannedReturnAt == plannedReturnAt &&
            other.freightCostCents == freightCostCents &&
            other.notes == notes &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        quoteId,
        vehicleId,
        driverTeamMemberId,
        plannedDepartureAt,
        plannedReturnAt,
        freightCostCents,
        notes,
        createdAt,
        updatedAt,
      );
}
