/// Operational state of a [Vehicle] in the logistics fleet.
///
/// Pure Dart — no Flutter dependency. UI labels live in this extension;
/// colors (if needed later) belong in presentation, not in the domain.
enum VehicleStatus {
  available,
  maintenance,
  unavailable,
  inactive,
}

extension VehicleStatusLabels on VehicleStatus {
  String get label => switch (this) {
        VehicleStatus.available => 'Disponível',
        VehicleStatus.maintenance => 'Manutenção',
        VehicleStatus.unavailable => 'Indisponível',
        VehicleStatus.inactive => 'Inativo',
      };
}
