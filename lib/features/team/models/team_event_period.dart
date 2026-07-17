/// Concrete local period used for team schedule overlap checks.
class TeamEventPeriod {
  const TeamEventPeriod({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;
}
