import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice_financial_summary.dart';
import 'invoice_financial_summary_service_provider.dart';

final invoiceFinancialSummaryProvider =
    FutureProvider.family<InvoiceFinancialSummary, String>((ref, quoteId) {
  return ref.watch(invoiceFinancialSummaryServiceProvider).forQuote(quoteId);
});
