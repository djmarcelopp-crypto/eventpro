/// Concrete local period used for vehicle logistics overlap checks.
class VehicleEventPeriod {
  const VehicleEventPeriod({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;
}
