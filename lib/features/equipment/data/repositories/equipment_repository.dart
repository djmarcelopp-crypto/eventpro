import 'package:eventpro/features/equipment/models/equipment.dart';

/// Domain contract for persisting [Equipment] records.
///
/// Storage-agnostic: no Drift (or other) implementation in this checkpoint.
/// Mirrors the pattern used by `FinancialEntryRepository` and
/// `AgendaBlockRepository`.
abstract class EquipmentRepository {
  Future<List<Equipment>> listAll();

  Future<Equipment?> findById(String id);

  Future<void> insert(Equipment equipment);

  Future<void> update(Equipment equipment);

  Future<void> delete(String id);
}
