import 'package:eventpro/features/catalog/data/repositories/catalog_repository.dart';
import 'package:eventpro/features/catalog/providers/catalog_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import 'fake_catalog_repository.dart';

List<Override> catalogRepositoryOverrides({CatalogRepository? repository}) {
  return [
    catalogRepositoryProvider.overrideWithValue(
      repository ?? FakeCatalogRepository(),
    ),
  ];
}
