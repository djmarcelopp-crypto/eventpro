import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/catalog/data/mappers/catalog_item_mapper.dart';
import 'package:eventpro/features/catalog/data/repositories/catalog_repository.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';

class DriftCatalogRepository implements CatalogRepository {
  DriftCatalogRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<CatalogItem>> listAll() async {
    final items = await _database.catalogDao.getAllItemsOrdered();
    final allComponents = await _database.catalogDao.getAllComponents();

    final componentsByPackageId = <String, List<CatalogPackageComponentRow>>{};
    for (final component in allComponents) {
      componentsByPackageId
          .putIfAbsent(component.packageId, () => [])
          .add(component);
    }

    return items
        .map(
          (row) => CatalogItemMapper.toDomain(
            row,
            components: componentsByPackageId[row.id] ?? const [],
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<CatalogItem?> findById(String id) async {
    final row = await _database.catalogDao.getItemById(id);
    if (row == null) {
      return null;
    }

    final components = await _database.catalogDao.getComponentsForPackage(id);
    return CatalogItemMapper.toDomain(row, components: components);
  }

  @override
  Future<void> insert(CatalogItem item) async {
    await _database.catalogDao.insertItemWithComponents(
      item: CatalogItemMapper.toInsertCompanion(item),
      components: CatalogItemMapper.toComponentCompanions(item),
    );
  }

  @override
  Future<void> update(CatalogItem item) async {
    final updated = await _database.catalogDao.updateItemWithComponents(
      item: CatalogItemMapper.toUpdateCompanion(item),
      components: CatalogItemMapper.toComponentCompanions(item),
      packageId: item.id,
    );
    if (!updated) {
      throw StateError('Catalog item not found for update: ${item.id}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final deleted = await _database.catalogDao.deleteById(id);
    if (!deleted) {
      throw StateError('Catalog item not found for delete: $id');
    }
  }
}
