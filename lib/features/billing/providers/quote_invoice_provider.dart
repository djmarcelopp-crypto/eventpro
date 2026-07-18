import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/invoice.dart';
import '../models/invoice_item_input.dart';
import '../models/invoice_operation_result.dart';
import '../models/invoice_type.dart';
import '../models/quote_invoice_summary.dart';
import '../utils/quote_invoice_service.dart';
import 'invoice_provider.dart';
import 'quote_invoice_service_provider.dart';

class QuoteInvoiceNotifier extends AsyncNotifier<List<Invoice>> {
  QuoteInvoiceNotifier(this.quoteId);

  final String quoteId;

  QuoteInvoiceService get _service => ref.read(quoteInvoiceServiceProvider);

  @override
  Future<List<Invoice>> build() async {
    final summary = await _service.summaryForQuote(quoteId);
    return summary.invoices;
  }

  Future<InvoiceOperationResult> generate({
    required List<InvoiceItemInput> items,
    InvoiceType type = InvoiceType.service,
    String? invoiceNumber,
    int taxCents = 0,
    int discountCents = 0,
    String notes = '',
  }) async {
    final result = await _service.generateForQuote(
      quoteId: quoteId,
      items: items,
      type: type,
      invoiceNumber: invoiceNumber,
      taxCents: taxCents,
      discountCents: discountCents,
      notes: notes,
    );
    if (result.isSuccess && result.invoice != null) {
      final current = state.value ?? const <Invoice>[];
      state = AsyncValue.data(
        List.unmodifiable([result.invoice!, ...current]),
      );
      ref.invalidate(invoiceProvider);
    }
    return result;
  }

  Future<InvoiceOperationResult> issue(String invoiceId) async {
    final result = await ref.read(invoiceProvider.notifier).issueInvoice(invoiceId);
    if (result.isSuccess) {
      ref.invalidateSelf();
    }
    return result;
  }

  Future<InvoiceOperationResult> registerPayment(String invoiceId) async {
    final result =
        await ref.read(invoiceProvider.notifier).markPaid(invoiceId);
    if (result.isSuccess && result.invoice != null) {
      _replace(result.invoice!);
    }
    return result;
  }

  Future<InvoiceOperationResult> cancel(String invoiceId) async {
    final result =
        await ref.read(invoiceProvider.notifier).cancelInvoice(invoiceId);
    if (result.isSuccess && result.invoice != null) {
      _replace(result.invoice!);
    }
    return result;
  }

  void _replace(Invoice invoice) {
    final current = state.value ?? const <Invoice>[];
    state = AsyncValue.data(
      List.unmodifiable([
        for (final item in current)
          if (item.id == invoice.id) invoice else item,
      ]),
    );
  }
}

final quoteInvoiceProvider = AsyncNotifierProvider.family<
  QuoteInvoiceNotifier,
  List<Invoice>,
  String
>(QuoteInvoiceNotifier.new);

final quoteInvoiceSummaryProvider =
    Provider.family<AsyncValue<QuoteInvoiceSummary>, String>((ref, quoteId) {
  return ref.watch(quoteInvoiceProvider(quoteId)).whenData(
        (invoices) => QuoteInvoiceSummary(
          quoteId: quoteId,
          invoices: invoices,
        ),
      );
});
