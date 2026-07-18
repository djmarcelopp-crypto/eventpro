import 'package:eventpro/features/catalog/data/repositories/catalog_repository.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';

class FakeCatalogRepository implements CatalogRepository {
  FakeCatalogRepository({List<CatalogItem>? initialItems})
    : _items = List<CatalogItem>.from(initialItems ?? const []);

  final List<CatalogItem> _items;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<CatalogItem>> listAll() async {
    _failIfRequested();
    return List<CatalogItem>.unmodifiable(_items);
  }

  @override
  Future<CatalogItem?> findById(String id) async {
    _failIfRequested();
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<void> insert(CatalogItem item) async {
    _failIfRequested();
    _items.add(item);
  }

  @override
  Future<void> update(CatalogItem item) async {
    _failIfRequested();
    final index = _items.indexWhere((current) => current.id == item.id);
    if (index == -1) {
      throw StateError('Catalog item not found for update: ${item.id}');
    }
    _items[index] = item;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _items.length;
    _items.removeWhere((item) => item.id == id);
    if (_items.length == lengthBefore) {
      throw StateError('Catalog item not found for delete: $id');
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
