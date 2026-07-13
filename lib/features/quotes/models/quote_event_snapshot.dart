class QuoteEventSnapshot {
  const QuoteEventSnapshot({
    this.name,
    this.type,
    this.date,
    this.startTime,
    this.endTime,
    this.venueName,
    this.addressSummary,
    this.guestCount,
  });

  final String? name;
  final String? type;
  final DateTime? date;
  final String? startTime;
  final String? endTime;
  final String? venueName;
  final String? addressSummary;
  final int? guestCount;

  static const empty = QuoteEventSnapshot();
}
