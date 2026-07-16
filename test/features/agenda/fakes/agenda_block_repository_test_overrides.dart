import 'package:eventpro/features/agenda/data/repositories/agenda_block_repository.dart';
import 'package:eventpro/features/agenda/providers/agenda_block_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import 'fake_agenda_block_repository.dart';

List<Override> agendaBlockRepositoryOverrides({
  AgendaBlockRepository? repository,
}) {
  return [
    agendaBlockRepositoryProvider.overrideWithValue(
      repository ?? FakeAgendaBlockRepository(),
    ),
  ];
}
