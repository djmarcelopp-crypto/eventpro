import '../models/invoice.dart';
import '../models/invoice_filters.dart';

abstract class InvoiceListFilter {
  static List<Invoice> apply(List<Invoice> invoices, InvoiceFilters filters) {
    final query = filters.numberQuery.trim().toLowerCase();
    return [
      for (final invoice in invoices)
        if ((filters.status == null || invoice.status == filters.status) &&
            (filters.type == null || invoice.type == filters.type) &&
            (query.isEmpty ||
                invoice.invoiceNumber.toLowerCase().contains(query) ||
                invoice.quoteId.toLowerCase().contains(query)))
          invoice,
    ];
  }
}
