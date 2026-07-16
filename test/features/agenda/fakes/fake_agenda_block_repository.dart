import 'package:eventpro/features/agenda/data/repositories/agenda_block_repository.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';

class FakeAgendaBlockRepository implements AgendaBlockRepository {
  FakeAgendaBlockRepository({List<AgendaBlock>? initialBlocks})
    : _blocks = List<AgendaBlock>.from(initialBlocks ?? const []);

  final List<AgendaBlock> _blocks;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<AgendaBlock>> listAll() async {
    _failIfRequested();
    return List<AgendaBlock>.unmodifiable(_blocks);
  }

  @override
  Future<AgendaBlock?> findById(String id) async {
    _failIfRequested();
    for (final block in _blocks) {
      if (block.id == id) {
        return block;
      }
    }
    return null;
  }

  @override
  Future<void> insert(AgendaBlock block) async {
    _failIfRequested();
    _blocks.add(block);
  }

  @override
  Future<void> update(AgendaBlock block) async {
    _failIfRequested();
    final index = _blocks.indexWhere((item) => item.id == block.id);
    if (index == -1) {
      throw StateError('AgendaBlock not found for update: ${block.id}');
    }
    _blocks[index] = block;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _blocks.length;
    _blocks.removeWhere((block) => block.id == id);
    if (_blocks.length == lengthBefore) {
      throw StateError('AgendaBlock not found for delete: $id');
    }
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) {
      return;
    }
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}
