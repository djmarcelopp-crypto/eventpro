import 'assistant_memory_entry.dart';
import 'assistant_memory_id.dart';
import 'assistant_memory_result.dart';
import 'assistant_memory_search.dart';
import 'assistant_memory_type.dart';

/// Port for Assistente persistent (operational) memory — AI-024 CP-2.
///
/// No concrete persistence technology is implied. Local engines may be
/// in-memory only. Not model memory, not a cache.
abstract class AssistantPersistentMemory {
  /// Store or replace a memory entry.
  Future<AssistantMemoryEntry> remember(AssistantMemoryEntry entry);

  /// Soft-remove a memory (status → forgotten).
  Future<bool> forget(AssistantMemoryId id);

  /// Query memories by structured criteria (no NLP).
  Future<AssistantMemoryResult> search(AssistantMemorySearch query);

  /// Find a single entry by id.
  Future<AssistantMemoryEntry?> find(AssistantMemoryId id);

  /// Update an existing entry; returns null if missing.
  Future<AssistantMemoryEntry?> update(AssistantMemoryEntry entry);

  /// Archive an entry (status → archived).
  Future<AssistantMemoryEntry?> archive(AssistantMemoryId id);

  /// List memories optionally filtered by type / scope / session.
  Future<AssistantMemoryResult> list({
    List<AssistantMemoryType> types = const [],
    List<AssistantMemoryScope> scopes = const [],
    String? sessionId,
    bool includeArchived = false,
    int limit = 50,
  });
}
