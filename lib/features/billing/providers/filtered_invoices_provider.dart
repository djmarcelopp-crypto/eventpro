import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice.dart';
import '../utils/invoice_list_filter.dart';
import 'invoice_filters_provider.dart';
import 'invoice_provider.dart';

final filteredInvoicesProvider = Provider<AsyncValue<List<Invoice>>>((ref) {
  final filters = ref.watch(invoiceFiltersProvider);
  return ref.watch(invoiceProvider).whenData(
        (invoices) => InvoiceListFilter.apply(invoices, filters),
      );
});
