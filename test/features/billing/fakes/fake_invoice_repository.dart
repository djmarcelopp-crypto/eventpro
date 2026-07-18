import 'package:eventpro/features/billing/data/repositories/invoice_repository.dart';
import 'package:eventpro/features/billing/models/invoice.dart';

class FakeInvoiceRepository implements InvoiceRepository {
  FakeInvoiceRepository({List<Invoice>? initialInvoices})
      : _invoices = List<Invoice>.from(initialInvoices ?? const []);

  final List<Invoice> _invoices;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<Invoice>> listAll() async {
    return List.unmodifiable(_invoices);
  }

  @override
  Future<Invoice?> findById(String id) async {
    for (final invoice in _invoices) {
      if (invoice.id == id) return invoice;
    }
    return null;
  }

  @override
  Future<List<Invoice>> listByQuoteId(String quoteId) async {
    final matches =
        _invoices.where((invoice) => invoice.quoteId == quoteId).toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return List.unmodifiable(matches);
  }

  @override
  Future<void> insert(Invoice invoice) async {
    _failIfRequested();
    _invoices.add(invoice);
  }

  @override
  Future<void> update(Invoice invoice) async {
    _failIfRequested();
    final index = _invoices.indexWhere((current) => current.id == invoice.id);
    if (index == -1) {
      throw StateError('Invoice not found for update: ${invoice.id}');
    }
    _invoices[index] = invoice;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _invoices.length;
    _invoices.removeWhere((invoice) => invoice.id == id);
    if (_invoices.length == lengthBefore) {
      throw StateError('Invoice not found for delete: $id');
    }
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) return;
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}
