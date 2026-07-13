import '../models/quote_status.dart';

abstract class QuoteStatusTransitions {
  static bool isAllowed(QuoteStatus current, QuoteStatus target) {
    if (current == target) {
      return false;
    }

    return switch (current) {
      QuoteStatus.draft =>
        target == QuoteStatus.sent || target == QuoteStatus.cancelled,
      QuoteStatus.sent => target == QuoteStatus.approved ||
          target == QuoteStatus.rejected ||
          target == QuoteStatus.cancelled,
      QuoteStatus.approved => target == QuoteStatus.cancelled ||
          target == QuoteStatus.draft,
      QuoteStatus.rejected => false,
      QuoteStatus.cancelled => false,
    };
  }
}
