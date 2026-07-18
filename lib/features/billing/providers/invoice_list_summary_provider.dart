import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice_list_summary.dart';
import 'invoice_provider.dart';

final invoiceListSummaryProvider =
    Provider<AsyncValue<InvoiceListSummary>>((ref) {
  return ref.watch(invoiceProvider).whenData(InvoiceListSummary.fromInvoices);
});
