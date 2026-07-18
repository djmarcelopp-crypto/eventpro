import 'package:eventpro/features/logistics/models/quote_vehicle.dart';
import 'package:eventpro/features/logistics/data/repositories/quote_vehicle_repository.dart';

class FakeQuoteVehicleRepository implements QuoteVehicleRepository {
  FakeQuoteVehicleRepository({List<QuoteVehicle>? initialItems})
      : _items = List<QuoteVehicle>.from(initialItems ?? const []);

  final List<QuoteVehicle> _items;

  @override
  Future<List<QuoteVehicle>> listAll() async =>
      List.unmodifiable(_items);

  @override
  Future<QuoteVehicle?> findById(String id) async {
    for (final item in _items) {
      if (item.id == id) return item;
    }
    return null;
  }

  @override
  Future<List<QuoteVehicle>> listByQuoteId(String quoteId) async {
    final matches =
        _items.where((item) => item.quoteId == quoteId).toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return List.unmodifiable(matches);
  }

  @override
  Future<void> insert(QuoteVehicle item) async {
    _items.add(item);
  }

  @override
  Future<void> update(QuoteVehicle item) async {
    final index = _items.indexWhere((current) => current.id == item.id);
    if (index == -1) {
      throw StateError('QuoteVehicle not found: ${item.id}');
    }
    _items[index] = item;
  }

  @override
  Future<void> delete(String id) async {
    final before = _items.length;
    _items.removeWhere((item) => item.id == id);
    if (_items.length == before) {
      throw StateError('QuoteVehicle not found: $id');
    }
  }
}
