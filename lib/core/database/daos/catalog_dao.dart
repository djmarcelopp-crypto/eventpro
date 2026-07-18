part of '../app_database.dart';

@DriftAccessor(tables: [CatalogItems, CatalogPackageComponents])
class CatalogDao extends DatabaseAccessor<AppDatabase> with _$CatalogDaoMixin {
  CatalogDao(super.db);

  Future<List<CatalogItemRow>> getAllItemsOrdered() {
    return (select(catalogItems)..orderBy([
          (row) => OrderingTerm.asc(row.createdAt),
          (row) => OrderingTerm.asc(row.id),
        ]))
        .get();
  }

  Future<CatalogItemRow?> getItemById(String id) {
    return (select(
      catalogItems,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
  }

  Future<List<CatalogPackageComponentRow>> getAllComponents() {
    return select(catalogPackageComponents).get();
  }

  Future<List<CatalogPackageComponentRow>> getComponentsForPackage(
    String packageId,
  ) {
    return (select(
      catalogPackageComponents,
    )..where((row) => row.packageId.equals(packageId))).get();
  }

  Future<void> insertItemWithComponents({
    required CatalogItemsCompanion item,
    required List<CatalogPackageComponentsCompanion> components,
  }) {
    return transaction(() async {
      await into(catalogItems).insert(item);
      for (final component in components) {
        await into(catalogPackageComponents).insert(component);
      }
    });
  }

  Future<bool> updateItemWithComponents({
    required CatalogItemsCompanion item,
    required List<CatalogPackageComponentsCompanion> components,
    required String packageId,
  }) {
    return transaction(() async {
      final updated = await update(catalogItems).replace(item);
      if (!updated) {
        return false;
      }

      await (delete(
        catalogPackageComponents,
      )..where((row) => row.packageId.equals(packageId))).go();

      for (final component in components) {
        await into(catalogPackageComponents).insert(component);
      }

      return true;
    });
  }

  Future<bool> deleteById(String id) {
    return (delete(
      catalogItems,
    )..where((row) => row.id.equals(id))).go().then((rows) => rows > 0);
  }
}
