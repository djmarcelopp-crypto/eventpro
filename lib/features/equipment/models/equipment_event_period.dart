/// Civil-date event window used for equipment reservation overlap checks.
///
/// Mirrors the agenda civil-date rules (optional `HH:mm`, overnight wrap) but
/// lives in the equipment module so availability does **not** integrate Agenda.
class EquipmentEventPeriod {
  const EquipmentEventPeriod({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;
}
