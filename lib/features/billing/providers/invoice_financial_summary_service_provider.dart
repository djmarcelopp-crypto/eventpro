import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/invoice_financial_summary_service.dart';
import 'invoice_repository_provider.dart';

final invoiceFinancialSummaryServiceProvider =
    Provider<InvoiceFinancialSummaryService>((ref) {
  return InvoiceFinancialSummaryService(
    invoiceRepository: ref.watch(invoiceRepositoryProvider),
  );
});
