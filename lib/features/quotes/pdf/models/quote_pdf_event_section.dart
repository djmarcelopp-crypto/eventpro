class QuotePdfEventSection {
  const QuotePdfEventSection({
    this.name,
    this.type,
    this.dateLabel,
    this.timeLabel,
    this.venueName,
    this.address,
    this.guestCountLabel,
  });

  final String? name;
  final String? type;
  final String? dateLabel;
  final String? timeLabel;
  final String? venueName;
  final String? address;
  final String? guestCountLabel;

  bool get isEmpty {
    return name == null &&
        type == null &&
        dateLabel == null &&
        timeLabel == null &&
        venueName == null &&
        address == null &&
        guestCountLabel == null;
  }
}
