import '../../models/quote.dart';

sealed class QuotePdfEligibilityResult {
  const QuotePdfEligibilityResult();
}

class QuotePdfEligibilityBlocked extends QuotePdfEligibilityResult {
  const QuotePdfEligibilityBlocked(this.message);

  final String message;
}

class QuotePdfEligibilityAllowed extends QuotePdfEligibilityResult {
  const QuotePdfEligibilityAllowed();
}

abstract class QuotePdfEligibility {
  static const missingCompanySnapshotMessage =
      'Este orçamento não possui os dados congelados da empresa emissora.';

  static QuotePdfEligibilityResult evaluate(Quote quote) {
    if (quote.companySnapshot == null) {
      return const QuotePdfEligibilityBlocked(missingCompanySnapshotMessage);
    }

    return const QuotePdfEligibilityAllowed();
  }
}
