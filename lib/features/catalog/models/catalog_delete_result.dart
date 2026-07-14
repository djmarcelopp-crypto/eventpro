enum CatalogDeleteStatus {
  deleted,
  blockedByPackages,
  deletedWithImageCleanupWarning,
  notFound,
  failure,
}

class CatalogDeleteResult {
  const CatalogDeleteResult({
    required this.status,
    this.blockingPackageNames = const [],
  });

  final CatalogDeleteStatus status;
  final List<String> blockingPackageNames;

  bool get isDeleted =>
      status == CatalogDeleteStatus.deleted ||
      status == CatalogDeleteStatus.deletedWithImageCleanupWarning;

  bool get isBlockedByPackages =>
      status == CatalogDeleteStatus.blockedByPackages;
}
