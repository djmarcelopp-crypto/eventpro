import 'equipment_status.dart';

/// A piece of equipment (or stockable item) managed by the inventory module.
///
/// Immutable domain entity. Persistence, providers and UI are intentionally
/// out of scope for the domain foundation checkpoint.
class Equipment {
  const Equipment({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.totalQuantity,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.description = '',
    this.serialNumber,
  });

  final String id;
  final String name;
  final String description;
  final String categoryId;

  /// Optional manufacturer / asset serial. `null` when not applicable.
  final String? serialNumber;

  /// Total owned quantity. Must be greater than zero (validated by
  /// [EquipmentValidator]).
  final int totalQuantity;

  final EquipmentStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isAvailable => status == EquipmentStatus.available;
  bool get isReserved => status == EquipmentStatus.reserved;
  bool get isInMaintenance => status == EquipmentStatus.maintenance;
  bool get isInactive => status == EquipmentStatus.inactive;

  Equipment copyWith({
    String? id,
    String? name,
    String? description,
    String? categoryId,
    String? serialNumber,
    int? totalQuantity,
    EquipmentStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearSerialNumber = false,
  }) {
    return Equipment(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      serialNumber:
          clearSerialNumber ? null : (serialNumber ?? this.serialNumber),
      totalQuantity: totalQuantity ?? this.totalQuantity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Equipment &&
            other.id == id &&
            other.name == name &&
            other.description == description &&
            other.categoryId == categoryId &&
            other.serialNumber == serialNumber &&
            other.totalQuantity == totalQuantity &&
            other.status == status &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        categoryId,
        serialNumber,
        totalQuantity,
        status,
        createdAt,
        updatedAt,
      );
}
