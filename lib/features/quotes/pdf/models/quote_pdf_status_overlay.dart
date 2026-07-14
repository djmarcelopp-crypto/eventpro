class QuotePdfStatusOverlay {
  const QuotePdfStatusOverlay({
    this.watermarkText,
    this.badgeText,
  });

  final String? watermarkText;
  final String? badgeText;

  bool get hasWatermark => watermarkText != null && watermarkText!.isNotEmpty;

  bool get hasBadge => badgeText != null && badgeText!.isNotEmpty;
}
