import 'package:eventpro/features/equipment/data/repositories/quote_equipment_repository.dart';
import 'package:eventpro/features/equipment/models/quote_equipment.dart';

class FakeQuoteEquipmentRepository implements QuoteEquipmentRepository {
  FakeQuoteEquipmentRepository({List<QuoteEquipment>? initialItems})
    : _items = List<QuoteEquipment>.from(initialItems ?? const []);

  final List<QuoteEquipment> _items;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<QuoteEquipment>> listAll() async {
    return List<QuoteEquipment>.unmodifiable(_items);
  }

  @override
  Future<QuoteEquipment?> findById(String id) async {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<List<QuoteEquipment>> listByQuoteId(String quoteId) async {
    final matches =
        _items.where((item) => item.quoteId == quoteId).toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return List<QuoteEquipment>.unmodifiable(matches);
  }

  @override
  Future<void> insert(QuoteEquipment item) async {
    _failIfRequested();
    _items.add(item);
  }

  @override
  Future<void> update(QuoteEquipment item) async {
    _failIfRequested();
    final index = _items.indexWhere((current) => current.id == item.id);
    if (index == -1) {
      throw StateError('QuoteEquipment not found for update: ${item.id}');
    }
    _items[index] = item;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _items.length;
    _items.removeWhere((item) => item.id == id);
    if (_items.length == lengthBefore) {
      throw StateError('QuoteEquipment not found for delete: $id');
    }
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) {
      return;
    }
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}
