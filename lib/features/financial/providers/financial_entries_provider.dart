import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/financial_entry_repository.dart';
import '../models/financial_entry.dart';
import '../models/financial_entry_delete_result.dart';
import '../models/financial_entry_write_result.dart';
import '../utils/financial_entry_service.dart';
import 'financial_entry_repository_provider.dart';
import 'financial_entry_service_provider.dart';

class FinancialEntriesNotifier extends AsyncNotifier<List<FinancialEntry>> {
  FinancialEntryRepository get _repository =>
      ref.read(financialEntryRepositoryProvider);

  FinancialEntryService get _service =>
      ref.read(financialEntryServiceProvider);

  @override
  Future<List<FinancialEntry>> build() async {
    return _repository.listAll();
  }

  /// Replaces state with [entries]. Used by tests (and future bootstrap) to
  /// hydrate without going through [build].
  void hydrate(List<FinancialEntry> entries) {
    state = AsyncValue.data(List<FinancialEntry>.unmodifiable(entries));
  }

  FinancialEntry? findById(String id) {
    final current = state.value;
    if (current == null) {
      return null;
    }
    for (final entry in current) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }

  Future<FinancialEntryWriteResult> addEntry(FinancialEntry draft) async {
    final result = await _service.create(draft);
    if (result.isSuccess && result.entry != null) {
      final current = state.value ?? const <FinancialEntry>[];
      final next = [...current, result.entry!]
        ..sort((a, b) => a.date.compareTo(b.date));
      state = AsyncValue.data(List<FinancialEntry>.unmodifiable(next));
    }
    return result;
  }

  Future<FinancialEntryWriteResult> updateEntry(FinancialEntry entry) async {
    final result = await _service.update(entry);
    if (result.isSuccess && result.entry != null) {
      final current = state.value ?? const <FinancialEntry>[];
      final next = [
        for (final item in current)
          if (item.id == result.entry!.id) result.entry! else item,
      ]..sort((a, b) => a.date.compareTo(b.date));
      state = AsyncValue.data(List<FinancialEntry>.unmodifiable(next));
    }
    return result;
  }

  Future<FinancialEntryDeleteResult> deleteEntry(String id) async {
    final result = await _service.delete(id);
    if (result.isDeleted) {
      final current = state.value ?? const <FinancialEntry>[];
      state = AsyncValue.data(
        List<FinancialEntry>.unmodifiable([
          for (final entry in current)
            if (entry.id != id) entry,
        ]),
      );
    }
    return result;
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_repository.listAll);
  }
}

final financialEntriesProvider =
    AsyncNotifierProvider<FinancialEntriesNotifier, List<FinancialEntry>>(
      FinancialEntriesNotifier.new,
    );
