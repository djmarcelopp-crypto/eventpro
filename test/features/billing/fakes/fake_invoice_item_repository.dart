import 'package:eventpro/features/billing/data/repositories/invoice_item_repository.dart';
import 'package:eventpro/features/billing/models/invoice_item.dart';

class FakeInvoiceItemRepository implements InvoiceItemRepository {
  FakeInvoiceItemRepository({List<InvoiceItem>? initialItems})
      : _items = List<InvoiceItem>.from(initialItems ?? const []);

  final List<InvoiceItem> _items;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<InvoiceItem>> listAll() async {
    return List.unmodifiable(_items);
  }

  @override
  Future<InvoiceItem?> findById(String id) async {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<List<InvoiceItem>> listByInvoiceId(String invoiceId) async {
    final matches =
        _items.where((item) => item.invoiceId == invoiceId).toList();
    return List.unmodifiable(matches);
  }

  @override
  Future<void> insert(InvoiceItem item) async {
    _failIfRequested();
    _items.add(item);
  }

  @override
  Future<void> update(InvoiceItem item) async {
    _failIfRequested();
    final index = _items.indexWhere((current) => current.id == item.id);
    if (index == -1) {
      throw StateError('InvoiceItem not found for update: ${item.id}');
    }
    _items[index] = item;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _items.length;
    _items.removeWhere((item) => item.id == id);
    if (_items.length == lengthBefore) {
      throw StateError('InvoiceItem not found for delete: $id');
    }
  }

  @override
  Future<void> deleteByInvoiceId(String invoiceId) async {
    _failIfRequested();
    _items.removeWhere((item) => item.invoiceId == invoiceId);
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) return;
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}
