import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/invoice_repository.dart';
import '../models/invoice.dart';
import '../models/invoice_item.dart';
import '../models/invoice_item_input.dart';
import '../models/invoice_operation_result.dart';
import '../models/invoice_type.dart';
import '../utils/invoice_service.dart';
import '../utils/invoice_workflow_service.dart';
import 'invoice_repository_provider.dart';
import 'invoice_service_provider.dart';
import 'invoice_workflow_service_provider.dart';

class InvoiceNotifier extends AsyncNotifier<List<Invoice>> {
  InvoiceRepository get _repository => ref.read(invoiceRepositoryProvider);
  InvoiceService get _service => ref.read(invoiceServiceProvider);
  InvoiceWorkflowService get _workflow =>
      ref.read(invoiceWorkflowServiceProvider);

  @override
  Future<List<Invoice>> build() async => _repository.listAll();

  Invoice? findById(String id) {
    final current = state.value;
    if (current == null) return null;
    for (final invoice in current) {
      if (invoice.id == id) return invoice;
    }
    return null;
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.listAll);
  }

  Future<InvoiceOperationResult> createInvoice({
    required String quoteId,
    required InvoiceType type,
    required List<InvoiceItemInput> items,
    String? invoiceNumber,
    int taxCents = 0,
    int discountCents = 0,
    String notes = '',
  }) async {
    final result = await _service.create(
      quoteId: quoteId,
      type: type,
      items: items,
      invoiceNumber: invoiceNumber,
      taxCents: taxCents,
      discountCents: discountCents,
      notes: notes,
    );
    if (result.isSuccess && result.invoice != null) {
      await _upsert(result.invoice!);
    }
    return result;
  }

  Future<InvoiceOperationResult> issueInvoice(String id) async {
    final result = await _workflow.issue(id);
    if (result.isSuccess && result.invoice != null) {
      await _upsert(result.invoice!);
    }
    return result;
  }

  Future<InvoiceOperationResult> markPaid(String id) async {
    final result = await _workflow.markPaid(id);
    if (result.isSuccess && result.invoice != null) {
      await _upsert(result.invoice!);
    }
    return result;
  }

  Future<InvoiceOperationResult> cancelInvoice(String id) async {
    final result = await _workflow.cancel(id);
    if (result.isSuccess && result.invoice != null) {
      await _upsert(result.invoice!);
    }
    return result;
  }

  Future<List<InvoiceItem>> loadItems(String invoiceId) {
    return _service.listItems(invoiceId);
  }

  Future<void> _upsert(Invoice invoice) async {
    final current = state.value ?? const <Invoice>[];
    final exists = current.any((item) => item.id == invoice.id);
    final next = exists
        ? [
            for (final item in current)
              if (item.id == invoice.id) invoice else item,
          ]
        : [invoice, ...current];
    next.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    state = AsyncValue.data(List.unmodifiable(next));
  }
}

final invoiceProvider =
    AsyncNotifierProvider<InvoiceNotifier, List<Invoice>>(InvoiceNotifier.new);
