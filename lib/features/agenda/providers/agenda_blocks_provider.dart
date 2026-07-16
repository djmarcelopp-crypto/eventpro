import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/repositories/agenda_block_repository.dart';
import '../models/agenda_block.dart';
import '../utils/agenda_block_validator.dart';
import 'agenda_block_clock_provider.dart';
import 'agenda_block_repository_provider.dart';

class AgendaBlocksNotifier extends AsyncNotifier<List<AgendaBlock>> {
  static const _uuid = Uuid();

  AgendaBlockRepository get _repository =>
      ref.read(agendaBlockRepositoryProvider);

  DateTime _now() => ref.read(agendaBlockClockProvider)();

  @override
  Future<List<AgendaBlock>> build() async => const [];

  List<AgendaBlock> get _current => state.value ?? const [];

  /// Substitui o state pela lista informada. Usado pelo bootstrap da
  /// aplicação (fora do escopo deste checkpoint) para hidratar os dados
  /// persistidos no startup, sem passar por build().
  void hydrate(List<AgendaBlock> blocks) {
    state = AsyncValue.data(blocks);
  }

  AgendaBlock? findById(String id) {
    for (final block in _current) {
      if (block.id == id) {
        return block;
      }
    }
    return null;
  }

  Future<bool> addBlock(AgendaBlock draft) async {
    final now = _now();
    final blockToSave = draft.copyWith(
      id: _uuid.v7(),
      createdAt: now,
      updatedAt: now,
    );

    final validation = AgendaBlockValidator.validate(blockToSave);
    if (!validation.isValid) {
      return false;
    }

    try {
      await _repository.insert(blockToSave);
      state = AsyncValue.data([..._current, blockToSave]);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateBlock(AgendaBlock block) async {
    final existing = findById(block.id);
    if (existing == null) {
      return false;
    }

    final updated = block.copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
      updatedAt: _now(),
    );

    final validation = AgendaBlockValidator.validate(updated);
    if (!validation.isValid) {
      return false;
    }

    try {
      await _repository.update(updated);
      state = AsyncValue.data([
        for (final item in _current)
          if (item.id == updated.id) updated else item,
      ]);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteBlock(String id) async {
    try {
      await _repository.delete(id);
      state = AsyncValue.data([
        for (final block in _current)
          if (block.id != id) block,
      ]);
      return true;
    } catch (_) {
      return false;
    }
  }
}

final agendaBlocksProvider =
    AsyncNotifierProvider<AgendaBlocksNotifier, List<AgendaBlock>>(
      AgendaBlocksNotifier.new,
    );
