import '../../settings/models/company_profile.dart';
import 'quote_date_formatter.dart';

class QuoteFormDefaultsValues {
  const QuoteFormDefaultsValues({
    required this.validUntil,
    this.publicNotes = '',
  });

  final DateTime validUntil;
  final String publicNotes;
}

abstract class QuoteFormDefaults {
  static const int fallbackValidityDays = 7;

  static QuoteFormDefaultsValues fromCompanyProfile(
    CompanyProfile? profile, {
    required DateTime clock,
  }) {
    final today = QuoteDateFormatter.dateOnly(clock);

    if (profile == null) {
      return QuoteFormDefaultsValues(
        validUntil: QuoteDateFormatter.addDays(today, fallbackValidityDays),
      );
    }

    return QuoteFormDefaultsValues(
      validUntil: QuoteDateFormatter.addDays(
        today,
        profile.quoteDefaults.defaultValidityDays,
      ),
      publicNotes: _publicNotes(profile),
    );
  }

  static String _publicNotes(CompanyProfile profile) {
    final notes = profile.quoteDefaults.defaultPublicNotes?.trim();
    if (notes == null || notes.isEmpty) {
      return '';
    }
    return notes;
  }
}
