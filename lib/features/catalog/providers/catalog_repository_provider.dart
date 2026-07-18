import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventpro/core/database/database_provider.dart';
import 'package:eventpro/features/catalog/data/repositories/catalog_repository.dart';
import 'package:eventpro/features/catalog/data/repositories/drift_catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftCatalogRepository(database);
});
