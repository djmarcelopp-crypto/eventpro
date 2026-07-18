import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/invoice_service.dart';
import 'billing_clock_provider.dart';
import 'invoice_item_repository_provider.dart';
import 'invoice_repository_provider.dart';

final invoiceServiceProvider = Provider<InvoiceService>((ref) {
  return InvoiceService(
    invoiceRepository: ref.watch(invoiceRepositoryProvider),
    itemRepository: ref.watch(invoiceItemRepositoryProvider),
    quoteRepository: ref.watch(quoteRepositoryProvider),
    clock: ref.watch(billingClockProvider),
  );
});
