import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/quote_invoice_service.dart';
import 'invoice_service_provider.dart';

final quoteInvoiceServiceProvider = Provider<QuoteInvoiceService>((ref) {
  return QuoteInvoiceService(
    invoiceService: ref.watch(invoiceServiceProvider),
  );
});
