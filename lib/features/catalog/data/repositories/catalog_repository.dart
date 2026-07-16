import 'package:eventpro/features/catalog/models/catalog_item.dart';

abstract class CatalogRepository {
  Future<List<CatalogItem>> listAll();

  Future<CatalogItem?> findById(String id);

  Future<void> insert(CatalogItem item);

  Future<void> update(CatalogItem item);

  Future<void> delete(String id);
}
