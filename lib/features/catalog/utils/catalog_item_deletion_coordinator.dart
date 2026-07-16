import '../data/services/catalog_image_storage_service.dart';
import '../models/catalog_delete_result.dart';
import '../models/catalog_item.dart';
import '../providers/catalog_provider.dart';
import 'catalog_package_dependency_checker.dart';

abstract class CatalogItemDeletionCoordinator {
  static Future<CatalogDeleteResult> deletePermanently({
    required String itemId,
    required CatalogNotifier notifier,
    required CatalogImageStorageService imageStorage,
    required List<CatalogItem> currentItems,
  }) async {
    final item = notifier.findById(itemId);
    if (item == null) {
      return const CatalogDeleteResult(status: CatalogDeleteStatus.notFound);
    }

    final blockingPackageNames =
        CatalogPackageDependencyChecker.dependentPackageNames(
      catalogItemId: itemId,
      items: currentItems,
    );

    if (blockingPackageNames.isNotEmpty) {
      return CatalogDeleteResult(
        status: CatalogDeleteStatus.blockedByPackages,
        blockingPackageNames: blockingPackageNames,
      );
    }

    final imageReference = item.imageReference;

    try {
      final deleteResult = await notifier.deleteItem(itemId);

      if (deleteResult.status == CatalogDeleteStatus.notFound) {
        return deleteResult;
      }

      if (imageReference == null) {
        return const CatalogDeleteResult(status: CatalogDeleteStatus.deleted);
      }

      try {
        await imageStorage.deleteCommitted(imageReference);
        return const CatalogDeleteResult(status: CatalogDeleteStatus.deleted);
      } catch (_) {
        return const CatalogDeleteResult(
          status: CatalogDeleteStatus.deletedWithImageCleanupWarning,
        );
      }
    } catch (_) {
      return const CatalogDeleteResult(status: CatalogDeleteStatus.failure);
    }
  }
}
