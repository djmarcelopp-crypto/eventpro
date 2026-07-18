import 'package:eventpro/features/billing/providers/billing_clock_provider.dart';
import 'package:eventpro/features/billing/providers/invoice_item_repository_provider.dart';
import 'package:eventpro/features/billing/providers/invoice_repository_provider.dart';
import 'package:eventpro/features/quotes/providers/quote_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../quotes/fakes/fake_quote_repository.dart';
import 'fake_invoice_item_repository.dart';
import 'fake_invoice_repository.dart';

List<Override> billingRepositoryOverrides({
  FakeInvoiceRepository? invoiceRepository,
  FakeInvoiceItemRepository? itemRepository,
  FakeQuoteRepository? quoteRepository,
  DateTime Function()? clock,
}) {
  return [
    invoiceRepositoryProvider.overrideWithValue(
      invoiceRepository ?? FakeInvoiceRepository(),
    ),
    invoiceItemRepositoryProvider.overrideWithValue(
      itemRepository ?? FakeInvoiceItemRepository(),
    ),
    quoteRepositoryProvider.overrideWithValue(
      quoteRepository ?? FakeQuoteRepository(),
    ),
    if (clock != null) billingClockProvider.overrideWithValue(clock),
  ];
}
