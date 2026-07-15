import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventpro/core/database/database_provider.dart';
import 'package:eventpro/features/clients/data/repositories/client_repository.dart';
import 'package:eventpro/features/clients/data/repositories/drift_client_repository.dart';

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftClientRepository(database);
});
