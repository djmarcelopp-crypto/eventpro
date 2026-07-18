/// Operational state of an [Equipment] item in inventory.
///
/// Pure Dart — no Flutter dependency. UI labels live in this extension;
/// colors (if needed later) belong in presentation, not in the domain.
enum EquipmentStatus {
  available,
  reserved,
  maintenance,
  inactive,
}

extension EquipmentStatusLabels on EquipmentStatus {
  String get label => switch (this) {
        EquipmentStatus.available => 'Disponível',
        EquipmentStatus.reserved => 'Reservado',
        EquipmentStatus.maintenance => 'Manutenção',
        EquipmentStatus.inactive => 'Inativo',
      };
}
