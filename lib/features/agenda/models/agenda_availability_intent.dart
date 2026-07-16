/// Recognized shape of a natural-language availability question, as
/// classified by `AgendaAvailabilityRequestParser`. Purely descriptive —
/// carries no logic; the actual query is always an `AgendaQuery` (CP-B).
enum AgendaAvailabilityIntent {
  /// "hoje"
  today,

  /// "amanhã"
  tomorrow,

  /// A specific civil day: a weekday name (e.g. "sábado") or an explicit
  /// `dd/MM/yyyy` date.
  specificDay,

  /// "esta semana" / bare mention of "semana".
  currentWeek,

  /// "próxima semana" / "semana que vem".
  nextWeek,

  /// "mês atual" / "este mês".
  currentMonth,

  /// A named month (e.g. "agosto"), resolved in the reference year.
  namedMonth,

  /// Two explicit `dd/MM/yyyy` dates, defining an inclusive range.
  dateRange,

  /// A specific civil day narrowed to a time-of-day interval
  /// (e.g. "entre 14h e 18h").
  timeRange,
}
