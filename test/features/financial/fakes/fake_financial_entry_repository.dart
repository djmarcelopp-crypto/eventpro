import 'package:eventpro/features/financial/data/repositories/financial_entry_repository.dart';
import 'package:eventpro/features/financial/models/financial_entry.dart';

class FakeFinancialEntryRepository implements FinancialEntryRepository {
  FakeFinancialEntryRepository({List<FinancialEntry>? initialEntries})
    : _entries = List<FinancialEntry>.from(initialEntries ?? const []);

  final List<FinancialEntry> _entries;

  /// Makes the next write (insert/update/delete) throw once, then resets
  /// itself. Reads (listAll/findById) are never affected, so tests can
  /// simulate a write failure without also breaking the existence checks
  /// `FinancialEntryService` performs before writing.
  var shouldFailOnNextOperation = false;

  @override
  Future<List<FinancialEntry>> listAll() async {
    return List<FinancialEntry>.unmodifiable(_entries);
  }

  @override
  Future<FinancialEntry?> findById(String id) async {
    for (final entry in _entries) {
      if (entry.id == id) {
        return entry;
      }
    }
    return null;
  }

  @override
  Future<void> insert(FinancialEntry entry) async {
    _failIfRequested();
    _entries.add(entry);
  }

  @override
  Future<void> update(FinancialEntry entry) async {
    _failIfRequested();
    final index = _entries.indexWhere((item) => item.id == entry.id);
    if (index == -1) {
      throw StateError('FinancialEntry not found for update: ${entry.id}');
    }
    _entries[index] = entry;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _entries.length;
    _entries.removeWhere((entry) => entry.id == id);
    if (_entries.length == lengthBefore) {
      throw StateError('FinancialEntry not found for delete: $id');
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
