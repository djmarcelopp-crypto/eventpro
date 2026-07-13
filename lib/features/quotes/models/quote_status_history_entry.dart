import 'quote_status.dart';

class QuoteStatusHistoryEntry {
  const QuoteStatusHistoryEntry({
    required this.previousStatus,
    required this.newStatus,
    required this.changedAt,
  });

  final QuoteStatus? previousStatus;
  final QuoteStatus newStatus;
  final DateTime changedAt;
}
