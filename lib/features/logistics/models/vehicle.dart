import 'vehicle_status.dart';

/// A vehicle in the logistics & transport fleet.
///
/// Immutable domain entity. Persistence, providers and UI are intentionally
/// out of scope for the domain foundation checkpoint.
///
/// Capacities are non-negative numbers validated by [VehicleValidator].
/// Plate uniqueness is enforced later in the service layer.
class Vehicle {
  const Vehicle({
    required this.id,
    required this.plate,
    required this.vehicleTypeId,
    required this.payloadCapacityKg,
    required this.volumeCapacityM3,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.description = '',
    this.observations = '',
  });

  final String id;

  /// License plate. Required and unique (uniqueness checked in the service).
  final String plate;

  final String description;
  final String vehicleTypeId;

  /// Payload capacity in kilograms. Must be >= 0.
  final double payloadCapacityKg;

  /// Volume capacity in cubic meters. Must be >= 0.
  final double volumeCapacityM3;

  final String observations;
  final VehicleStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isAvailable => status == VehicleStatus.available;
  bool get isInMaintenance => status == VehicleStatus.maintenance;
  bool get isUnavailable => status == VehicleStatus.unavailable;
  bool get isInactive => status == VehicleStatus.inactive;

  Vehicle copyWith({
    String? id,
    String? plate,
    String? description,
    String? vehicleTypeId,
    double? payloadCapacityKg,
    double? volumeCapacityM3,
    String? observations,
    VehicleStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vehicle(
      id: id ?? this.id,
      plate: plate ?? this.plate,
      description: description ?? this.description,
      vehicleTypeId: vehicleTypeId ?? this.vehicleTypeId,
      payloadCapacityKg: payloadCapacityKg ?? this.payloadCapacityKg,
      volumeCapacityM3: volumeCapacityM3 ?? this.volumeCapacityM3,
      observations: observations ?? this.observations,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Vehicle &&
            other.id == id &&
            other.plate == plate &&
            other.description == description &&
            other.vehicleTypeId == vehicleTypeId &&
            other.payloadCapacityKg == payloadCapacityKg &&
            other.volumeCapacityM3 == volumeCapacityM3 &&
            other.observations == observations &&
            other.status == status &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        plate,
        description,
        vehicleTypeId,
        payloadCapacityKg,
        volumeCapacityM3,
        observations,
        status,
        createdAt,
        updatedAt,
      );
}
