import 'invoice_status.dart';
import 'invoice_type.dart';

class InvoiceFilters {
  const InvoiceFilters({
    this.status,
    this.type,
    this.numberQuery = '',
  });

  static const empty = InvoiceFilters();

  final InvoiceStatus? status;
  final InvoiceType? type;
  final String numberQuery;

  bool get hasActiveFilters =>
      status != null || type != null || numberQuery.trim().isNotEmpty;

  InvoiceFilters copyWith({
    InvoiceStatus? status,
    InvoiceType? type,
    String? numberQuery,
    bool clearStatus = false,
    bool clearType = false,
  }) {
    return InvoiceFilters(
      status: clearStatus ? null : (status ?? this.status),
      type: clearType ? null : (type ?? this.type),
      numberQuery: numberQuery ?? this.numberQuery,
    );
  }
}
