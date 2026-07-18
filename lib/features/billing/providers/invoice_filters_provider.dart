import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice_filters.dart';
import '../models/invoice_status.dart';
import '../models/invoice_type.dart';

class InvoiceFiltersNotifier extends Notifier<InvoiceFilters> {
  @override
  InvoiceFilters build() => InvoiceFilters.empty;

  void setStatus(InvoiceStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
  }

  void setType(InvoiceType? type) {
    state = state.copyWith(type: type, clearType: type == null);
  }

  void setNumberQuery(String query) {
    state = state.copyWith(numberQuery: query);
  }

  void clear() {
    state = InvoiceFilters.empty;
  }
}

final invoiceFiltersProvider =
    NotifierProvider<InvoiceFiltersNotifier, InvoiceFilters>(
      InvoiceFiltersNotifier.new,
    );
