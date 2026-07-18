import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eventpro/core/database/database_provider.dart';
import 'package:eventpro/features/agenda/data/repositories/agenda_block_repository.dart';
import 'package:eventpro/features/agenda/data/repositories/drift_agenda_block_repository.dart';

final agendaBlockRepositoryProvider = Provider<AgendaBlockRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return DriftAgendaBlockRepository(database);
});
