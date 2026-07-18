import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice_workflow_summary.dart';
import 'invoice_provider.dart';
import 'invoice_workflow_service_provider.dart';

/// Workflow summary for an invoice id, derived from [invoiceProvider] state.
final invoiceWorkflowSummaryProvider =
    Provider.family<AsyncValue<InvoiceWorkflowSummary?>, String>((ref, id) {
  final workflow = ref.watch(invoiceWorkflowServiceProvider);
  return ref.watch(invoiceProvider).whenData((invoices) {
    for (final invoice in invoices) {
      if (invoice.id == id) {
        return workflow.summarize(invoice);
      }
    }
    return null;
  });
});
