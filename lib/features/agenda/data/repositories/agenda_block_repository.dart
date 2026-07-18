import 'package:eventpro/features/agenda/models/agenda_block.dart';

abstract class AgendaBlockRepository {
  Future<List<AgendaBlock>> listAll();

  Future<AgendaBlock?> findById(String id);

  Future<void> insert(AgendaBlock block);

  Future<void> update(AgendaBlock block);

  Future<void> delete(String id);
}
