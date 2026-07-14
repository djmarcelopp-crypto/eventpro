import '../../models/quote_status.dart';

abstract class QuotePdfAcceptancePolicy {
  static bool shouldIncludeAcceptanceSection(QuoteStatus status) {
    return switch (status) {
      QuoteStatus.sent || QuoteStatus.approved => true,
      QuoteStatus.draft ||
      QuoteStatus.rejected ||
      QuoteStatus.cancelled =>
        false,
    };
  }
}
